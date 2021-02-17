# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Checks if the preceding words increase, decrease, or negate/nullify the valence
    class PreviousWordsInfluenceChecker
      # @param [String] word
      # @param [Float] valence
      # @param [Boolean] is_cap_diff
      def initialize(word, valence, is_cap_diff)
        @word = word
        @word_lower = word.downcase
        @valence = valence
        @is_cap_diff = is_cap_diff
        @scalar = 0.0
      end

      # @return [Float]
      def call
        return @scalar unless word_in_booster_dictionary?

        take_scalar_from_dictionary
        @scalar *= -1 if @valence.negative?
        amplify_scalar_by_word_case

        @scalar
      end

      private

      def word_in_booster_dictionary?
        Constants::BOOSTER_DICT.keys.include?(@word_lower)
      end

      def take_scalar_from_dictionary
        @scalar = Constants::BOOSTER_DICT[@word_lower]
      end

      def amplify_scalar_by_word_case
        # Check if booster/dampener word is in ALLCAPS (while others aren't)
        return unless WordHelper.word_upcase?(@word) && @is_cap_diff

        amplified_scalar
      end

      def amplified_scalar
        if @valence.positive?
          @scalar += Constants::C_INCR
        else
          @scalar -= Constants::C_INCR
        end
      end
    end
  end
end
