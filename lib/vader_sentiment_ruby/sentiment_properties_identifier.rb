# frozen_string_literal: true

module VaderSentimentRuby
  # Identify sentiment-relevant string-level properties of input text.
  class SentimentPropertiesIdentifier
    attr_reader :words_and_emoticons, :is_cap_diff

    # @param [String] text
    def initialize(text)
      text = text.to_s.encode('utf-8') unless text.is_a? String
      @text = text
      @words_and_emoticons = prepare_words_and_emoticons
      # Doesn't separate words from adjacent punctuation (keeps emoticons & contractions)
      @is_cap_diff = text_contains_mixed_cases?
    end

    private

    # Removes leading and trailing punctuation
    # Leaves contractions and most emoticons
    # @return [Array]
    def prepare_words_and_emoticons
      @text
        .split
        .map { |word| WordHelper.strip_punctuation(word) }
    end

    # Check whether just some words in the input are ALL CAPS.
    # Returns `True` if some but not all items in `words` are ALL CAPS
    # @return [Boolean]
    def text_contains_mixed_cases?
      uppercase_words = @words_and_emoticons.count { |word| WordHelper.word_upcase?(word) }

      uppercase_words.positive? && uppercase_words < @words_and_emoticons.size
    end
  end
end
