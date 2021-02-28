# frozen_string_literal: true

RSpec.describe VaderSentimentRuby::PunctuationEmphasisAmplifier do
  describe '#call' do
    subject { -> { described_class.new(text).call } }

    context 'with only question marks' do
      context 'when one' do
        let(:text) { 'Test?' }

        it { expect(subject.call).to eq(0) }
      end

      context 'when two' do
        let(:text) { 'Test??' }

        it { expect(subject.call).to eq(0.36) }
      end

      context 'when three' do
        let(:text) { 'Test???' }

        it { expect(subject.call).to eq(0.54) }
      end

      context 'when four' do
        let(:text) { 'Test????' }

        it { expect(subject.call).to eq(0.96) }
      end

      context 'when five' do
        let(:text) { 'Test?????' }

        it { expect(subject.call).to eq(0.96) }
      end
    end

    context 'with only exclamation marks' do
      context 'when one' do
        let(:text) { 'Test!' }

        it { expect(subject.call).to eq(0.292) }
      end

      context 'when two' do
        let(:text) { 'Test!!' }

        it { expect(subject.call).to eq(0.584) }
      end

      context 'when three' do
        let(:text) { 'Test!!!' }

        it { expect(subject.call).to eq(0.876) }
      end

      context 'when four' do
        let(:text) { 'Test!!!!' }

        it { expect(subject.call).to eq(1.168) }
      end

      context 'when five' do
        let(:text) { 'Test!!!!!' }

        it { expect(subject.call).to eq(1.168) }
      end
    end

    context 'with both question and exclamation marks' do
      let(:text) { '?????Test!!!!!' }

      it { expect(subject.call).to eq(2.128) }
    end

    context 'without both question and exclamation marks' do
      let(:text) { 'Test' }

      it { expect(subject.call).to eq(0) }
    end
  end
end
