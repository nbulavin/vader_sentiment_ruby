# frozen_string_literal: true

module VaderSentimentRuby
  # Returns a sentiment intensity score for sentences.
  class SentimentIntensityAnalyzer
    def initialize
      @lexicon = LexiconDictionaryCreator.new.call
      @emojis = EmojisDictionaryCreator.new.call
    end

    # Returns a float for sentiment strength based on the input text.
    # Positive values are positive valence, negative value are negative valence.
    # @param [String] text Text to analyze
    # @return [Hash] Hash of sentiments for analyzed text
    def polarity_scores(text)
      text = EmojiDescriber.new(text, @emojis).call
      senti_text = SentimentPropertiesIdentifier.new(text)

      sentiments = []
      words_and_emoticons = senti_text.words_and_emoticons
      words_and_emoticons.each_with_index do |item, index|
        sentiments << prepare_valence(item, index, words_and_emoticons, senti_text)
      end

      sentiments = Checker::ButWordNegationChecker.new(words_and_emoticons, sentiments).call

      ValenceScoreCalculator.new(sentiments, text).call
    end

    private

    def prepare_valence(item, index, words_and_emoticons, senti_text)
      valence = 0

      # Check for vader_lexicon words that may be used as modifiers or negations
      return valence if Constants::BOOSTER_DICT.keys.include?(item.downcase)

      if index < words_and_emoticons.size - 1 &&
         item.downcase == 'kind' &&
         (words_and_emoticons[index + 1]).downcase == 'of'
        return valence
      end

      sentiment_valence(valence, senti_text, item, index)
    end

    def sentiment_valence(valence, senti_text, item, index)
      item_lowercase = item.downcase

      if @lexicon.keys.include?(item_lowercase)
        valence = calculate_valence_for_word_in_lexicon(item, item_lowercase, index, senti_text)
      end

      valence
    end

    def calculate_valence_for_word_in_lexicon(item, item_lowercase, index, senti_text)
      is_cap_diff = senti_text.is_cap_diff
      words_and_emoticons = senti_text.words_and_emoticons

      valence = @lexicon[item_lowercase] # get the sentiment valence
      valence = Checker::NoWordChecker.new(valence, item_lowercase, index, words_and_emoticons, @lexicon).call
      # Check if sentiment laden word is in ALL CAPS (while others aren't)
      valence = apply_intensity_rating(valence) if WordHelper.word_upcase?(item) && is_cap_diff
      valence = modify_valence_by_scalar(valence, index, words_and_emoticons, is_cap_diff)
      Checker::LeastWordNegationChecker.new(valence, words_and_emoticons, index, @lexicon).call
    end

    def apply_intensity_rating(valence)
      return valence + Constants::C_INCR if valence.positive?

      valence - Constants::C_INCR
    end

    # Dampen the scalar modifier of preceding words and emoticons
    # (excluding the ones that immediately precede the item) based
    # on their distance from the current item.
    def modify_valence_by_scalar(valence, index, words_and_emoticons, is_cap_diff)
      (0..2).each do |start_index|
        next unless index > start_index
        next if @lexicon.keys.include?((words_and_emoticons[index - (start_index + 1)]).downcase)

        valence = apply_scalar(valence, words_and_emoticons, index, start_index, is_cap_diff)
        valence = Checker::NegationChecker.new(valence, words_and_emoticons, start_index, index).call
        valence = Checker::SpecialIdiomsChecker.new(valence, words_and_emoticons, index).call if start_index == 2
      end

      valence
    end

    def apply_scalar(valence, words_and_emoticons, index, start_index, is_cap_diff)
      previous_word = words_and_emoticons[index - (start_index + 1)]
      scalar = Checker::PreviousWordsInfluenceChecker.new(previous_word, valence, is_cap_diff).call
      valence + adjust_scalar(scalar, start_index)
    end

    def adjust_scalar(scalar, start_index)
      return scalar if scalar.zero?

      scalar *= 0.95 if start_index == 1
      scalar *= 0.9 if start_index == 2
      scalar
    end
  end
end
