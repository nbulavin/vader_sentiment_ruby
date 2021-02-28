# frozen_string_literal: true

RSpec.describe VaderSentimentRuby::WordHelper do
  describe '.word_upcase?' do
    subject { -> { described_class.word_upcase?(word) } }

    context 'when contains only letters' do
      context 'when all letters are in uppercase' do
        let(:word) { 'UPPERCASE' }

        it { expect(subject.call).to eq(true) }
      end

      context 'when letters are partially in uppercase' do
        let(:word) { 'MIXEDcase' }

        it { expect(subject.call).to eq(false) }
      end

      context 'when all letters are not in uppercase' do
        let(:word) { 'lowercase' }

        it { expect(subject.call).to eq(false) }
      end
    end

    context 'when contains letters and punctuation' do
      context 'when all letters are in uppercase' do
        let(:word) { 'UPPERCASE:)' }

        it { expect(subject.call).to eq(true) }
      end

      context 'when letters are partially in uppercase' do
        let(:word) { 'MIXEDcase:)' }

        it { expect(subject.call).to eq(false) }
      end

      context 'when all letters are not in uppercase' do
        let(:word) { 'lowercase:)' }

        it { expect(subject.call).to eq(false) }
      end
    end

    context 'when does not contain letters' do
      let(:word) { ':)' }

      it { expect(subject.call).to eq(false) }
    end
  end

  describe '.strip_punctuation' do
    subject { -> { described_class.strip_punctuation(word) } }

    [
      { original_word: 'test', result: 'test' },
      { original_word: 'te\'st', result: 'te\'st' },
      { original_word: ':test:', result: 'test' },
      { original_word: ':(test:)', result: 'test' },
      { original_word: '!"#$test!}~', result: 'test' },
      { original_word: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~test', result: 'test' },
      { original_word: 'test!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~', result: 'test' },
      { original_word: 'te!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~st', result: 'te!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~st' },
      { original_word: '-./:;<=>?@[\\]^_`{|}~test!"#$%&\'()*+,', result: 'test' },
      { original_word: ':)', result: ':)' },
      { original_word: '-./:;<=>?@[\\]^_`{|}~!"#$%&\'()*+,', result: '-./:;<=>?@[\\]^_`{|}~!"#$%&\'()*+,' }
    ].each do |test_case|
      describe "correctly handles #{test_case[:original_word]}" do
        let(:word) { test_case[:original_word] }

        it { expect(subject.call).to eq(test_case[:result]) }
      end
    end
  end
end
