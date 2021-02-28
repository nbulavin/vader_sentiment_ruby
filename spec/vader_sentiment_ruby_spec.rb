# frozen_string_literal: true

RSpec.describe VaderSentimentRuby do
  it 'has a version number' do
    expect(VaderSentimentRuby::VERSION).to eq('0.1.1')
  end

  describe '.polarity_scores' do
    subject { -> { described_class.polarity_scores(text) } }

    describe 'calculates score correctly' do
      [
        {
          text: 'VADER is smart, handsome, and funny.',
          scores: { negative: 0, neutral: 0.254, positive: 0.746, compound: 0.8316 }
        },
        {
          text: 'VADER is smart, handsome, and funny!',
          scores: { negative: 0.0, neutral: 0.248, positive: 0.752, compound: 0.8439 }
        },
        {
          text: 'VADER is very smart, handsome, and funny.',
          scores: { negative: 0.0, neutral: 0.299, positive: 0.701, compound: 0.8545 }
        },
        {
          text: 'VADER is VERY SMART, handsome, and FUNNY.',
          scores: { negative: 0.0, neutral: 0.246, positive: 0.754, compound: 0.9227 }
        },
        {
          text: 'VADER is VERY SMART, handsome, and FUNNY!!!',
          scores: { negative: 0.0, neutral: 0.233, positive: 0.767, compound: 0.9342 }
        },
        {
          text: 'VADER is VERY SMART, really handsome, and INCREDIBLY FUNNY!!!',
          scores: { negative: 0.0, neutral: 0.294, positive: 0.706, compound: 0.9469 }
        },
        {
          text: 'VADER is VERY SMART, uber handsome, and FRIGGIN FUNNY!!!',
          scores: { negative: 0.0, neutral: 0.294, positive: 0.706, compound: 0.9469 }
        },
        {
          text: 'VADER is not smart, handsome, nor funny.',
          scores: { negative: 0.646, neutral: 0.354, positive: 0.0, compound: -0.7424 }
        },
        {
          text: 'The book was good.',
          scores: { negative: 0.0, neutral: 0.508, positive: 0.492, compound: 0.4404 }
        },
        {
          text: 'At least it isn\'t a horrible book.',
          scores: { negative: 0.0, neutral: 0.678, positive: 0.322, compound: 0.431 }
        },
        {
          text: 'The book was only kind of good.',
          scores: { negative: 0.0, neutral: 0.697, positive: 0.303, compound: 0.3832 }
        },
        {
          text: 'The plot was good, but the characters are uncompelling and the dialog is not great.',
          scores: { negative: 0.327, neutral: 0.579, positive: 0.094, compound: -0.7042 }
        },
        {
          text: 'Today SUX!',
          scores: { negative: 0.779, neutral: 0.221, positive: 0.0, compound: -0.5461 }
        },
        {
          text: 'Today sux!',
          scores: { negative: 0.736, neutral: 0.264, positive: 0.0, compound: -0.4199 }
        },
        {
          text: 'Today sux',
          scores: { negative: 0.714, neutral: 0.286, positive: 0.0, compound: -0.3612 }
        },
        {
          text: 'Today kinda sux! But I\'ll get by, lol',
          scores: { negative: 0.138, neutral: 0.517, positive: 0.344, compound: 0.5249 }
        },
        {
          text: 'Today only kinda sux! But I\'ll get by, lol',
          scores: { negative: 0.127, neutral: 0.556, positive: 0.317, compound: 0.5249 }
        },
        {
          text: 'Make sure you :) or :D today!',
          scores: { negative: 0.0, neutral: 0.294, positive: 0.706, compound: 0.8633 }
        },
        {
          text: 'Not bad at all',
          scores: { negative: 0.0, neutral: 0.513, positive: 0.487, compound: 0.431 }
        },
        {
          text: 'Not GREATLY bad at all!!!!!',
          scores: { negative: 0.0, neutral: 0.456, positive: 0.544, compound: 0.6982 }
        },
        {
          text: 'Not GREATLY bad at all??',
          scores: { negative: 0.0, neutral: 0.502, positive: 0.498, compound: 0.6084 }
        },
        {
          text: 'Not GREATLY bad at all????',
          scores: { negative: 0.0, neutral: 0.467, positive: 0.533, compound: 0.6777 }
        },
        {
          text: 'Not least GREATLY bad at all????',
          scores: { negative: 0.0, neutral: 0.523, positive: 0.477, compound: 0.6777 }
        },
        {
          text: 'Not GREATLY least bad at all????',
          scores: { negative: 0.436, neutral: 0.564, positive: 0.0, compound: -0.5944 }
        },
        {
          text: 'Catch utf-8 emoji such as such as💘 and 💋 and 😁',
          scores: { negative: 0.0, neutral: 0.746, positive: 0.254, compound: 0.7003 }
        },
        {
          text: 'least bad at all????',
          scores: { negative: 0.0, neutral: 0.441, positive: 0.559, compound: 0.5873 }
        },
        {
          text: 'No not GREATLY least bad at all????',
          scores: { negative: 0.548, neutral: 0.452, positive: 0.0, compound: -0.7238 }
        },
        {
          text: 'No not GREATLY @#$%^least@#$%^&*( bad at:) all????',
          scores: { negative: 0.548, neutral: 0.452, positive: 0.0, compound: -0.7238 }
        },
        {
          text: 'The book was only kind of no good.',
          scores: { negative: 0.381, neutral: 0.619, positive: 0.0, compound: -0.4017 }
        },
        {
          text: 'The book was only kind of bad ass good.',
          scores: { negative: 0.246, neutral: 0.422, positive: 0.331, compound: 0.0534 }
        },
        {
          text: 'The book was only kind of never so bad ass good.',
          scores: { negative: 0.0, neutral: 0.516, positive: 0.484, compound: 0.7579 }
        },
        {
          text: 'The book was only kind of without doubt bad ass good.',
          scores: { negative: 0.0, neutral: 0.412, positive: 0.588, compound: 0.8406 }
        },
        {
          text: 'The book was only kind of badn\'t ass good.',
          scores: { negative: 0.196, neutral: 0.571, positive: 0.233, compound: 0.1139 }
        },
        {
          text: 'The food is great, but the service is horrible but',
          scores: { negative: 0.31, neutral: 0.523, positive: 0.167, compound: -0.4939 }
        },
        {
          text: 'The food is great, and the service is horrible',
          scores: { negative: 0.24, neutral: 0.479, positive: 0.281, compound: 0.1531 }
        },
        {
          text: 'The food is really great',
          scores: { negative: 0.0, neutral: 0.477, positive: 0.523, compound: 0.6590 }
        },
        {
          text: ' ',
          scores: { negative: 0.0, neutral: 0.0, positive: 0.0, compound: 0.0 }
        },
        {
          text: '',
          scores: { negative: 0.0, neutral: 0.0, positive: 0.0, compound: 0.0 }
        }
      ].each do |test_case|
        describe "for phrase \"#{test_case[:text]}\"" do
          let(:text) { test_case[:text] }

          it { expect(subject.call).to match(test_case[:scores]) }
        end
      end
    end
  end
end
