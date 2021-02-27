# frozen_string_literal: true

RSpec.describe VaderSentimentRuby::SentimentScoresSifter do
  describe '#call' do
    subject { -> { described_class.new(sentiments).call } }

    describe 'correctly calculates score' do
      context 'when only positive' do
        let(:sentiments) { [0.1, 0.2, 1] }

        it { expect(subject.call).to eq([4.3, 0.0, 0]) }
      end

      context 'when only zero' do
        let(:sentiments) { [0, 0, 0] }

        it { expect(subject.call).to eq([0.0, 0.0, 3]) }
      end

      context 'when only negative' do
        let(:sentiments) { [-0.1, -0.2, -1] }

        it { expect(subject.call).to eq([0.0, -4.3, 0]) }
      end

      context 'when mixed' do
        let(:sentiments) { [-0.1, 0.2, 0, -1, 0.8] }

        it { expect(subject.call).to eq([3.0, -3.1, 1]) }
      end
    end
  end
end
