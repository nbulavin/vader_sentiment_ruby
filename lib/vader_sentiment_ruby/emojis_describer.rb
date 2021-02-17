# frozen_string_literal: true

module VaderSentimentRuby
  # Replaces emoji char with its description
  class EmojiDescriber
    def initialize(text, emojis)
      @text = text
      @emojis = emojis
      @text_no_emoji = ''
      @prev_space = true
    end

    def call
      @text.split('').each do |chr|
        if @emojis.keys.include?(chr)
          handle_emoji_presence(chr)
        else
          handle_emoji_absence(chr)
        end
      end

      @text_no_emoji
    end

    private

    def handle_emoji_presence(emoji)
      description = @emojis[emoji]
      @text_no_emoji += ' ' unless @prev_space
      @text_no_emoji += description
      @prev_space = false
    end

    def handle_emoji_absence(character)
      @text_no_emoji += character
      @prev_space = character == ' '
    end
  end
end
