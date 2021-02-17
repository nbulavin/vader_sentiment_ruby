# VaderSentimentRuby

VADER (Valence Aware Dictionary and sEntiment Reasoner) is a lexicon and rule-based sentiment analysis tool that is specifically attuned to sentiments expressed in social media.

This is a port of [VADER sentiment analysis tool](https://github.com/cjhutto/vaderSentiment) originally written in Python. If you'd like to make a contribution, please checkout the original author's work.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'vader_sentiment_ruby'
```
And then execute:
```ruby
bundle install
```
Or install it yourself as:
```ruby
gem install vader_sentiment_ruby
```
## Usage
```ruby
require 'vader_sentiment_ruby'

VaderSentimentRuby.polarity_scores('VADER is smart, handsome, and funny.')
# => {:negative=>0.0, :neutral=>0.254, :positive=>0.746, :compound=>0.8316}
```

## About the Scoring
The compound score is computed by summing the valence scores of each word in the lexicon, adjusted according to the rules, and then normalized to be between -1 (most extreme negative) and +1 (most extreme positive). This is the most useful metric if you want a single unidimensional measure of sentiment for a given sentence. Calling it a 'normalized, weighted composite score' is accurate.

It is also useful for researchers who would like to set standardized thresholds for classifying sentences as either positive, neutral, or negative. Typical threshold values (used in the literature cited on this page) are:

    positive sentiment: compound score >= 0.05
    neutral sentiment: (compound score > -0.05) and (compound score < 0.05)
    negative sentiment: compound score <= -0.05

The pos, neu, and neg scores are ratios for proportions of text that fall in each category (so these should all add up to be 1... or close to it with float operation). These are the most useful metrics if you want multidimensional measures of sentiment for a given sentence.

## Citation Information
If you use either the dataset or any of the VADER sentiment analysis tools (VADER sentiment lexicon or Rust code for rule-based sentiment analysis engine) in your research, please cite the above paper. For example:

> Hutto, C.J. & Gilbert, E.E. (2014). VADER: A Parsimonious Rule-based Model for Sentiment Analysis of Social Media Text. Eighth International Conference on Weblogs and Social Media (ICWSM-14). Ann Arbor, MI, June 2014.

For questions, please contact: C.J. Hutto Georgia Institute of Technology, Atlanta, GA 30032
cjhutto [at] gatech [dot] edu

## License
The original source code is copyright © 2013 C.J. Hutto

This port gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
