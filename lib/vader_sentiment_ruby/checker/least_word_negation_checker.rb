# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Checks for negation case using "least"
    class LeastWordNegationChecker
      def initialize(valence, words_and_emoticons, index, lexicon)
        @valence = valence
        @words_and_emoticons = words_and_emoticons
        @index = index
        @lexicon = lexicon
      end

      def call
        valence = @valence
        return valence unless !word_in_lexicon?(@index - 1) && word_is?(@index - 1, 'least')

        if @index > 1
          valence *= Constants::N_SCALAR if !word_is?(@index - 2, 'at') && !word_is?(@index - 2, 'very')
        elsif @index.positive?
          valence *= Constants::N_SCALAR
        end

        valence
      end

      private

      def word_in_lexicon?(index)
        @lexicon.keys.include?(@words_and_emoticons[index].downcase)
      end

      def word_is?(index, word)
        @words_and_emoticons[index].downcase == word
      end
    end
  end
end
