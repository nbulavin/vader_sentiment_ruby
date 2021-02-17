# frozen_string_literal: true

module VaderSentimentRuby
  # Adds emphasis from exclamation points and question marks
  class PunctuationEmphasisAmplifier
    # @param [String] text
    def initialize(text)
      @text = text
    end

    # @return [Float]
    def call
      amplify_exclamation_points + amplify_question_marks
    end

    def amplify_exclamation_points
      # check for added emphasis resulting from exclamation points (up to 4 of them)
      ep_count = @text.split('').count('!')
      ep_count = 4.0 if ep_count > 4

      # empirically derived mean sentiment intensity rating increase for exclamation points
      ep_count * 0.292
    end

    def amplify_question_marks
      # check for added emphasis resulting from question marks (2 or 3+)
      qm_count = @text.split('').count('?')

      return 0.0 unless qm_count > 1
      # empirically derived mean sentiment intensity rating increase for question marks
      return qm_count * 0.18 if qm_count <= 3

      0.96
    end
  end
end
