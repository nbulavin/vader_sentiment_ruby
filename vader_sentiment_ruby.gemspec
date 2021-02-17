# frozen_string_literal: true

require_relative 'lib/vader_sentiment_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'vader_sentiment_ruby'
  spec.version       = VaderSentimentRuby::VERSION
  spec.authors       = ['Nickolay Bulavin']
  spec.email         = ['bulavinnik@gmail.com']

  spec.summary       = 'VADER Sentiment Analysis in Ruby'
  spec.description   = 'VADER (Valence Aware Dictionary and sEntiment Reasoner) is a lexicon and rule-based' \
                       ' sentiment analysis tool that is specifically attuned to sentiments expressed in social media.'
  spec.homepage      = 'https://github.com/nbulavin/vader_sentiment_ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/nbulavin/vader_sentiment_ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/nbulavin/vader_sentiment_ruby/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.glob('lib/**/*') + %w[LICENSE.txt README.md]
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.9'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.2'
end
