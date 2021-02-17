# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Check for "no" as negation for an adjacent lexicon item vs "no" as its own stand-alone lexicon item
    class NoWordChecker
      # @param [Float] valence
      # @param [String] item_lowercase
      # @param [Integer] index
      # @param [Array] words_and_emoticons
      # @param [Hash] lexicon
      def initialize(valence, item_lowercase, index, words_and_emoticons, lexicon)
        @valence = valence
        @item_lowercase = item_lowercase
        @index = index
        @words_and_emoticons = words_and_emoticons
        @lexicon = lexicon
      end

      # @return [Float]
      def call
        valence = @valence

        if @item_lowercase == 'no' &&
           @index != @words_and_emoticons.size - 1 &&
           @lexicon.keys.include?(@words_and_emoticons[@index + 1].downcase)
          # don't use valence of "no" as a lexicon item. Instead set it's valence to 0.0 and negate the next item
          valence = 0.0
        end

        valence = @lexicon[@item_lowercase] * Constants::N_SCALAR if one_of_preceding_words_is_no?

        valence
      end

      private

      def one_of_preceding_words_is_no?
        preceding_word_is_no?(0) ||
          preceding_word_is_no?(1) ||
          (preceding_word_is_no?(2) && %w[or nor].include?(@words_and_emoticons[@index - 1].downcase))
      end

      def preceding_word_is_no?(distance)
        @index > distance && @words_and_emoticons[@index - (distance + 1)].downcase == 'no'
      end
    end
  end
end
