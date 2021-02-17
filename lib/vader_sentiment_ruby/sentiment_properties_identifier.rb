# frozen_string_literal: true

module VaderSentimentRuby
  # Identify sentiment-relevant string-level properties of input text.
  class SentimentPropertiesIdentifier
    attr_reader :is_cap_diff, :words_and_emoticons

    # @param [String] text
    def initialize(text)
      text = text.to_s.encode('utf-8') unless text.is_a? String
      @text = text
      @words_and_emoticons = prepare_words_and_emoticons
      # Doesn't separate words from adjacent punctuation (keeps emoticons & contractions)
      @is_cap_diff = all_cap_differential?(@words_and_emoticons)
    end

    private

    # Removes leading and trailing punctuation
    # Leaves contractions and most emoticons
    # Does not preserve punc-plus-letter emoticons (e.g. :D)
    # @return [Array]
    def prepare_words_and_emoticons
      @text
        .split
        .map { |word| WordHelper.strip_punctuation(word) }
    end

    # Check whether just some words in the input are ALL CAPS.
    # Returns `True` if some but not all items in `words` are ALL CAPS
    # @param [Array] words
    # @return [Boolean]
    def all_cap_differential?(words)
      all_cap_words = 0

      words.each do |word|
        all_cap_words += 1 if WordHelper.word_upcase?(word)
      end

      words_size = words.size
      cap_differential = words_size - all_cap_words

      return true if cap_differential.positive? && cap_differential < words_size

      false
    end
  end
end
