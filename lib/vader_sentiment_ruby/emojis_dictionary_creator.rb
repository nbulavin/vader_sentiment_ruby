# frozen_string_literal: true

module VaderSentimentRuby
  # Converts emoji lexicon file to a dictionary
  class EmojisDictionaryCreator
    # @return [Hash]
    def call
      emoji_file = File.open("#{__dir__}/data/emoji_utf8_lexicon.txt").read
      emoji_dict = {}
      lines = emoji_file.strip.split("\n")
      lines.each do |line|
        next unless line

        emoji, description = line.strip.split("\t")[0..1]
        emoji_dict[emoji] = description
      end

      emoji_dict
    end
  end
end
