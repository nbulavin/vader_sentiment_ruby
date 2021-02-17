# frozen_string_literal: true

module VaderSentimentRuby
  # Used only for checkers autoload
  module Checker
    autoload(:ButWordNegationChecker, 'vader_sentiment_ruby/checker/but_word_negation_checker')
    autoload(:LeastWordNegationChecker, 'vader_sentiment_ruby/checker/least_word_negation_checker')
    autoload(:NegationChecker, 'vader_sentiment_ruby/checker/negation_checker')
    autoload(:NoWordChecker, 'vader_sentiment_ruby/checker/no_word_checker')
    autoload(:PreviousWordsInfluenceChecker, 'vader_sentiment_ruby/checker/previous_words_influence_checker')
    autoload(:SpecialIdiomsChecker, 'vader_sentiment_ruby/checker/special_idioms_checker')
  end
end
