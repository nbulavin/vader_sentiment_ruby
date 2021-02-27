# frozen_string_literal: true

module VaderSentimentRuby
  # Helper module for word manipulations to simulate pythons methods behavior
  # word_upcase?(word) is similar to Python's word.isupper()
  # strip_punctuation(word) is similar to Python's word.strip(string.punctuation)
  module WordHelper
    LETTERS_RANGE = 'A-Za-z'
    PUNCTUATIONS = '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'

    class << self
      # Checks that string contains at least one letter and all letters are in upcase
      # @param [String] word
      # @return [Boolean]
      #
      # Example
      #   word_upcase?(':D') # => true
      #   word_upcase?(':)') # => false
      def word_upcase?(word)
        word == word.upcase && word.count(LETTERS_RANGE).positive?
      end

      # Removes all trailing and leading punctuation
      # If the resulting string has two or fewer characters,
      # then it was likely an emoticon, so return original string
      # (ie ':)' stripped would be '', so just return ':)'
      # @param [String] token
      # @return [String]
      #
      # Example
      #   strip_punctuation("'test'") # => "test"
      #   strip_punctuation("'don't'") # => "don't"
      #   strip_punctuation(":)") # => ":)"
      def strip_punctuation(token)
        original_set = token.split('')

        array = clean_leading_punctuations(original_set)
        array = clean_trailing_punctuations(array)
        stripped_token = array.join

        return token if stripped_token.size <= 2

        stripped_token
      end

      private

      def clean_leading_punctuations(token_array)
        token_array.drop_while { |letter| PUNCTUATIONS.include? letter }
      end

      def clean_trailing_punctuations(token_array)
        token_array
          .reverse
          .drop_while { |letter| PUNCTUATIONS.include? letter }
          .reverse
      end
    end
  end
end
