# frozen_string_literal: true

module VaderSentimentRuby
  module Checker
    # Checks for modification in sentiment due to contrastive conjunction 'but'
    class ButWordNegationChecker
      def initialize(words_and_emoticons, sentiments)
        @words_and_emoticons_lower = words_and_emoticons.map { |w| w.to_s.downcase }
        @sentiments = sentiments
      end

      def call
        return @sentiments unless @words_and_emoticons_lower.include?('but')

        but_index = @words_and_emoticons_lower.index('but')
        updated_sentiments = []
        @sentiments.each_with_index do |sentiment, senti_index|
          updated_sentiments << modified_sentiment(sentiment, senti_index, but_index)
        end

        updated_sentiments
      end

      private

      def modified_sentiment(sentiment, senti_index, but_index)
        return sentiment * 0.5 if senti_index < but_index
        return sentiment * 1.5 if senti_index > but_index

        sentiment
      end
    end
  end
end
