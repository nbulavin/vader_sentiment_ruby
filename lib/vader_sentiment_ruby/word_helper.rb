# frozen_string_literal: true

module VaderSentimentRuby
  # Helper module for word manipulations to simulate pythons methods behavior
  # word_upcase?(word) is similar to Python's word.isupper()
  # strip_punctuation(word) is similar to Python's word.strip(string.punctuation)
  module WordHelper
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
        word == word.upcase && word.count('A-Za-z').positive?
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
        token_without_punctuation = replace_punctuations(token)

        original_set = token.split('')
        updated_set = token_without_punctuation.split('')

        pair_array = prepare_match_array(original_set, updated_set)
        pair_array = clean_leading_punctuations(pair_array)
        pair_array = clean_trailing_punctuations(pair_array)

        stripped = pair_array.map { |item| item[:old_ch] }.join

        return token if stripped.size <= 2

        stripped
      end

      private

      def replace_punctuations(token)
        punctuation_array = PUNCTUATIONS.split('')

        punctuation_array.each do |punctuation|
          token = token.gsub(punctuation, ' ')
        end

        token
      end

      def prepare_match_array(original_set, updated_set)
        pair_array = []
        original_set.each_with_index do |item, index|
          pair_array << { index: index, old_ch: item, new_ch: updated_set[index] }
        end

        pair_array
      end

      def clean_leading_punctuations(pair_array)
        pair_array.map do |pair|
          break if pair[:new_ch] != ' '

          pair_array.delete_at(pair[:index])
        end

        pair_array
      end

      def clean_trailing_punctuations(pair_array)
        reversed_array = pair_array.reverse
        reversed_array.map do |pair|
          break if pair[:new_ch] != ' '

          pair_array.delete_at(pair[:index])
        end

        pair_array
      end
    end
  end
end
