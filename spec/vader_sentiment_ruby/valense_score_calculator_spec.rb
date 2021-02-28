# frozen_string_literal: true

RSpec.describe VaderSentimentRuby::ValenceScoreCalculator do
  describe '#call' do
    subject { -> { described_class.new(sentiments, text).call } }

    context 'when sentiments not empty' do
      let(:sentiments) { [0.89, 0.1, 1] }
      let(:text) { 'test text text2' }

      it { expect(subject.call).to match({ negative: 0.0, neutral: 0.0, positive: 1.0, compound: 0.457 }) }
    end

    context 'when sentiments are empty' do
      let(:sentiments) { [] }
      let(:text) { '' }

      it { expect(subject.call).to match({ negative: 0.0, neutral: 0.0, positive: 0.0, compound: 0.0 }) }
    end
  end
end
