# frozen_string_literal: true

RSpec.describe VaderSentimentRuby::EmojiDescriber do
  describe '#call' do
    subject { -> { described_class.new(text, emoji_dictionary).call } }

    # Stubbed emoji dictionary with fake descriptions for test only
    let(:emoji_dictionary) do
      {
        '💘' => 'heart',
        '💋' => 'red lips',
        '😁' => 'ROFL'
      }
    end

    context 'when text has no emojis' do
      let(:text) { 'Simple text without any emojis' }

      it { expect(subject.call).to eq('Simple text without any emojis') }
    end

    context 'when text contains emojis and words' do
      let(:text) { 'Simple text💘 with 😁 emojis💋' }

      it { expect(subject.call).to eq('Simple text heart with ROFL emojis red lips') }
    end

    context 'when text contains only emojis' do
      context 'when separated by spaces' do
        let(:text) { '💘 💋  😁' }

        it { expect(subject.call).to eq('heart red lips  ROFL') }
      end

      context 'when written together' do
        let(:text) { '💘💋😁' }

        it { expect(subject.call).to eq('heart red lips ROFL') }
      end
    end
  end
end
