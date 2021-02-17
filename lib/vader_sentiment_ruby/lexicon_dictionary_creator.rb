# frozen_string_literal: true

module VaderSentimentRuby
  # Converts lexicon file to a dictionary
  class LexiconDictionaryCreator
    # @return [Hash]
    def call
      lexicon_file = File.open("#{__dir__}/data/vader_lexicon.txt").read
      lex_dict = {}
      lines = lexicon_file.strip.split("\n")
      lines.each do |line|
        next unless line

        word, measure = line.strip.split("\t")[0..1]
        lex_dict[word] = measure.to_f
      end

      lex_dict
    end
  end
end
