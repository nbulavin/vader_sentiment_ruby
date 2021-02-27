# frozen_string_literal: true

module VaderSentimentRuby
  # Adds emphasis factor from exclamation points and question marks
  class PunctuationEmphasisAmplifier
    EXCLAMATION_MARK = '!'
    QUESTION_MARK = '?'
    # Empirically derived mean sentiment intensity rating increases for exclamation points and question marks
    EXCLAMATION_MARK_RATING_INCREASE = 0.292
    QUESTION_MARK_RATING_INCREASE = 0.18

    # @param [String] text
    def initialize(text)
      @text_array = text.split('')
    end

    # @return [Float, Integer] Emphasis factor
    def call
      (amplify_exclamation_points + amplify_question_marks).round(3)
    end

    private

    def amplify_exclamation_points
      # Check for added emphasis resulting from exclamation points (up to 4 of them)
      ep_count = @text_array.count(EXCLAMATION_MARK)
      ep_count = 4 if ep_count > 4

      ep_count * EXCLAMATION_MARK_RATING_INCREASE
    end

    def amplify_question_marks
      # Check for added emphasis resulting from question marks (2 or 3+)
      qm_count = @text_array.count(QUESTION_MARK)

      return 0 unless qm_count > 1
      return 0.96 if qm_count > 3

      qm_count * QUESTION_MARK_RATING_INCREASE
    end
  end
end
