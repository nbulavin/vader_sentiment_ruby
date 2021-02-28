# frozen_string_literal: true

module VaderSentimentRuby
  # Prepares response with semantic score
  class ValenceScoreCalculator
    DEFAULT_RESPONSE = {
      negative: 0.0,
      neutral: 0.0,
      positive: 0.0,
      compound: 0.0
    }.freeze

    # @param [Array<Float, Integer>] sentiments Array of sentiments for text
    # @param [String] text
    def initialize(sentiments, text)
      @sentiments = sentiments
      @text = text
    end

    # @return [Hash<Float, Float, Float, Float>] Semantic score response hash
    def call
      return DEFAULT_RESPONSE if @sentiments.empty?

      sum_s = @sentiments.map(&:to_f).sum
      # Compute and add emphasis from punctuation in text
      punct_emph_amplifier = PunctuationEmphasisAmplifier.new(@text).call
      compound = normalize(sum_s, punct_emph_amplifier)

      prepare_response(compound, punct_emph_amplifier)
    end

    private

    # Normalizes the score to be between -1 and 1 using an alpha that approximates the max expected value
    def normalize(score, punct_emph_amplifier, alpha = 15)
      score = add_punctuation_emphasis(score, punct_emph_amplifier)
      norm_score = score / Math.sqrt((score * score) + alpha).to_f

      return -1.0 if norm_score < -1.0
      return 1.0 if norm_score > 1.0

      norm_score
    end

    def add_punctuation_emphasis(sum_s, punct_emph_amplifier)
      return sum_s + punct_emph_amplifier if sum_s.positive?
      return sum_s - punct_emph_amplifier if sum_s.negative?

      sum_s
    end

    # rubocop:disable Metrics/AbcSize
    def prepare_response(compound, punct_emph_amplifier)
      pos_sum, neg_sum, neu_count = scores(punct_emph_amplifier)
      total = (pos_sum + neg_sum.to_f.abs) + neu_count

      {
        negative: (neg_sum / total.to_f).abs.round(3),
        neutral: (neu_count / total.to_f).abs.round(3),
        positive: (pos_sum / total.to_f).abs.round(3),
        compound: compound.round(4)
      }
    end
    # rubocop:enable Metrics/AbcSize

    # Prepares score sums for result calculation
    def scores(punct_emph_amplifier)
      # Discriminate between positive, negative and neutral sentiment scores
      pos_sum, neg_sum, neu_count = SentimentScoresSifter.new(@sentiments).call

      if pos_sum > neg_sum.to_f.abs
        pos_sum += punct_emph_amplifier
      elsif pos_sum < neg_sum.to_f.abs
        neg_sum -= punct_emph_amplifier
      end

      [pos_sum, neg_sum, neu_count]
    end
  end
end
