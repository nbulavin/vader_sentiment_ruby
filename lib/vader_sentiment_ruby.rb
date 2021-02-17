# frozen_string_literal: true

# VaderSentimentRuby namespace
module VaderSentimentRuby
  autoload(:Constants, 'vader_sentiment_ruby/constants')
  autoload(:WordHelper, 'vader_sentiment_ruby/word_helper')
  autoload(:LexiconDictionaryCreator, 'vader_sentiment_ruby/lexicon_dictionary_creator')
  autoload(:EmojisDictionaryCreator, 'vader_sentiment_ruby/emojis_dictionary_creator')
  autoload(:PunctuationEmphasisAmplifier, 'vader_sentiment_ruby/punctuation_emphasis_amplifier')
  autoload(:SentimentScoresSifter, 'vader_sentiment_ruby/sentiment_scores_sifter')
  autoload(:SentimentIntensityAnalyzer, 'vader_sentiment_ruby/sentiment_intensity_analyzer')
  autoload(:ValenceScoreCalculator, 'vader_sentiment_ruby/valence_score_calculator')
  autoload(:EmojiDescriber, 'vader_sentiment_ruby/emojis_describer')
  autoload(:SentimentPropertiesIdentifier, 'vader_sentiment_ruby/sentiment_properties_identifier')
  autoload(:Checker, 'vader_sentiment_ruby/checker')

  def self.polarity_scores(text)
    VaderSentimentRuby::SentimentIntensityAnalyzer.new.polarity_scores(text)
  end
end
