# frozen_string_literal: true

RSpec.describe VaderSentimentRuby::SentimentPropertiesIdentifier do
  describe '.new' do
    subject { -> { described_class.new(text) } }

    describe 'correctly calculates is_cap_diff' do
      context 'when all words ara in uppercase' do
        let(:text) { 'THIS IS FINE' }

        it { expect(subject.call.is_cap_diff).to eq(false) }
      end

      context 'when all words are in lowercase' do
        let(:text) { 'this is fine' }

        it { expect(subject.call.is_cap_diff).to eq(false) }
      end

      context 'when words in mixed case' do
        let(:text) { 'THIS is FIne' }

        it { expect(subject.call.is_cap_diff).to eq(true) }
      end

      context 'when string is empty' do
        let(:text) { '' }

        it { expect(subject.call.is_cap_diff).to eq(false) }
      end
    end

    describe 'correctly prepares words_and_emoticons' do
      let(:text) { ':D THIS IS "absolutely usual" sentence:)' }

      it { expect(subject.call.words_and_emoticons).to eq(%w[:D THIS IS absolutely usual sentence]) }
    end
  end
end
