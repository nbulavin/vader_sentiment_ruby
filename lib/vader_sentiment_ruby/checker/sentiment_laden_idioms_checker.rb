# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Not implemented
    # check for sentiment laden idioms that don't contain a lexicon word
    class SentimentLadenIdiomsChecker
      def initialize(valence, senti_text_lower)
        @valence = valence
        @senti_text_lower = senti_text_lower
      end

      def call
        idioms_valences = []
        valence = @valence

        Constants::SENTIMENT_LADEN_IDIOMS.each do |idiom|
          next unless @senti_text_lower.include?(idiom)

          valence = Constants::SENTIMENT_LADEN_IDIOMS[idiom]
          idioms_valences.push(valence)
        end

        valence = idioms_valences.sum / idioms_valences.size.to_f if idioms_valences.size.positive?

        valence
      end
    end
  end
end
