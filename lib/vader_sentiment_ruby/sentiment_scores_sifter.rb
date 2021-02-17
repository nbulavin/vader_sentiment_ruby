# frozen_string_literal: true

module VaderSentimentRuby
  # Separates positive versus negative sentiment scores
  class SentimentScoresSifter
    def initialize(sentiments)
      @sentiments = sentiments
      @pos_sum = 0.0
      @neg_sum = 0.0
      @neu_count = 0
    end

    def call
      @sentiments.each do |sentiment_score|
        # compensates for neutral words that are counted as 1
        @pos_sum += sentiment_score.to_f + 1 if sentiment_score.positive?

        # when used with .abs, compensates for neutrals
        @neg_sum += sentiment_score.to_f - 1 if sentiment_score.negative?

        @neu_count += 1 if sentiment_score.zero?
      end

      [@pos_sum, @neg_sum, @neu_count]
    end
  end
end
