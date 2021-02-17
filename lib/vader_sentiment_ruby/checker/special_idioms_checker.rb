# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Checks text for special idioms
    class SpecialIdiomsChecker
      # @param [Float] valence Current valence
      # @param [Array] words_and_emoticons Array of words
      # @param [Integer] index Current word index
      def initialize(valence, words_and_emoticons, index)
        @valence = valence
        @words_and_emoticons_lower = words_and_emoticons.map { |word| word.to_s.downcase }
        @index = index
      end

      # @return [Float]
      def call
        valence = @valence

        valence = update_valence_checking_preceding_words(valence)

        valence = update_valence_checking_subsequent_words(valence)

        update_valence_checking_n_grams(valence)
      end

      private

      def update_valence_checking_preceding_words(current_valence)
        valence = current_valence
        sequences.each do |seq|
          if Constants::SPECIAL_CASES.keys.include?(seq)
            valence = Constants::SPECIAL_CASES[seq]
            break
          end
        end

        valence
      end

      # rubocop:disable Metrics/AbcSize
      def sequences
        [
          "#{words[:first_before]} #{words[:current]}",
          "#{words[:second_before]} #{words[:first_before]} #{words[:current]}",
          "#{words[:second_before]} #{words[:first_before]}",
          "#{words[:third_before]} #{words[:second_before]} #{words[:first_before]}",
          "#{words[:third_before]} #{words[:second_before]}"
        ]
      end
      # rubocop:enable Metrics/AbcSize

      def update_valence_checking_subsequent_words(current_valence)
        valence = current_valence

        valence = update_valence_checking_two_words(valence) if @words_and_emoticons_lower.size - 1 > @index
        valence = update_valence_checking_three_words(valence) if @words_and_emoticons_lower.size - 1 > @index + 1

        valence
      end

      def update_valence_checking_two_words(current_valence)
        zero_one = "#{words[:current]} #{words[:first_after]}"
        return current_valence unless Constants::SPECIAL_CASES.keys.include?(zero_one)

        Constants::SPECIAL_CASES[zero_one]
      end

      def update_valence_checking_three_words(current_valence)
        zero_one_two = "#{words[:current]} #{words[:first_after]} #{words[:second_after]}"
        return current_valence unless Constants::SPECIAL_CASES.keys.include?(zero_one_two)

        Constants::SPECIAL_CASES[zero_one_two]
      end

      # check for booster/dampener bi-grams such as 'sort of' or 'kind of'
      def update_valence_checking_n_grams(current_valence)
        valence = current_valence

        n_grams.each do |n_gram|
          valence += Constants::BOOSTER_DICT[n_gram] if Constants::BOOSTER_DICT.keys.include?(n_gram)
        end

        valence
      end

      def n_grams
        [
          "#{words[:third_before]} #{words[:second_before]} #{words[:first_before]}",
          "#{words[:third_before]} #{words[:second_before]}",
          "#{words[:second_before]} #{words[:first_before]}"
        ]
      end

      def words
        @words ||= {
          third_before: @words_and_emoticons_lower[@index - 3],
          second_before: @words_and_emoticons_lower[@index - 2],
          first_before: @words_and_emoticons_lower[@index - 1],
          current: @words_and_emoticons_lower[@index],
          first_after: @words_and_emoticons_lower[@index + 1],
          second_after: @words_and_emoticons_lower[@index + 2]
        }
      end
    end
  end
end
