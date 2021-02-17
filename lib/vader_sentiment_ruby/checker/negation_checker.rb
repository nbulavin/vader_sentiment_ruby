# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Checks for negation
    class NegationChecker
      # @param [Float] valence
      # @param [Array(String)] words_and_emoticons
      # @param [Integer] start_index
      # @param [Integer] index
      def initialize(valence, words_and_emoticons, start_index, index)
        @valence = valence
        @words_and_emoticons_lower = words_and_emoticons.map { |word| word.to_s.downcase }
        @start_index = start_index
        @index = index
      end

      # @return [Float]
      def call
        valence = @valence
        valence = check_zero_index(valence) if @start_index.zero?
        valence = check_first_index(valence) if @start_index == 1
        valence = check_second_index(valence) if @start_index == 2

        valence
      end

      private

      def check_zero_index(valence)
        # 1 word preceding lexicon word (w/o stopwords)
        return valence unless negated?([@words_and_emoticons_lower[@index - (@start_index + 1)]])

        valence * Constants::N_SCALAR
      end

      def check_first_index(valence)
        return valence * 1.25 if word_is_never?(-2) && (word_is_so?(-1) || word_is_this?(-1))
        return valence if word_is_without?(-2) && word_is_doubt?(-1)

        if negated?([@words_and_emoticons_lower[@index - (@start_index + 1)]])
          # 2 words preceding the lexicon word position
          return valence * Constants::N_SCALAR
        end

        valence
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def check_second_index(valence)
        if word_is_never?(-3) &&
           (word_is_so?(-2) || word_is_this?(-2)) ||
           (word_is_so?(-1) || word_is_this?(-1))
          return valence * 1.25
        elsif word_is_without?(-3) && (word_is_doubt?(-2) || word_is_doubt?(-1))
          return valence
        elsif negated?([@words_and_emoticons_lower[@index - (@start_index + 1)]])
          # 3 words preceding the lexicon word position
          return valence * Constants::N_SCALAR
        end

        valence
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      # Determine if input contains negation words
      def negated?(input_words, include_nt: true)
        input_words = input_words.map { |w| w.to_s.downcase }
        Constants::NEGATE.each do |word|
          return true if input_words.include?(word)
        end

        if include_nt
          input_words.each do |word|
            return true if word.include?("n't")
          end
        end

        # if input_words.include?('least')
        #   index = input_words.index('least')
        #   return true if index.positive? && input_words[index - 1] != 'at'
        # end

        false
      end

      def word_is_never?(index_shift)
        word_is?(index_shift, 'never')
      end

      def word_is_so?(index_shift)
        word_is?(index_shift, 'so')
      end

      def word_is_this?(index_shift)
        word_is?(index_shift, 'this')
      end

      def word_is_without?(index_shift)
        word_is?(index_shift, 'without')
      end

      def word_is_doubt?(index_shift)
        word_is?(index_shift, 'doubt')
      end

      def word_is?(index_shift, word)
        @words_and_emoticons_lower[@index + index_shift].downcase == word
      end
    end
  end
end
