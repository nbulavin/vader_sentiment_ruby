# frozen_string_literal: true

module VaderSentimentRuby
  # Replaces emoji characters with their descriptions
  class EmojiDescriber
    # @param [String] text Original text
    # @param [Hash] emoji_dictionary Emoji dictionary with emojis as keys
    def initialize(text, emoji_dictionary)
      @text_array = text.split('')
      @emoji_dictionary = emoji_dictionary
      @text_no_emoji = ''
      @prev_space = true
    end

    # @return [String] Text with emojis replaced with descriptions
    def call
      @text_array.each do |character|
        if @emoji_dictionary.keys.include?(character)
          replace_emoji_with_description(character)
        else
          handle_simple_character(character)
        end
      end

      @text_no_emoji
    end

    private

    def replace_emoji_with_description(emoji)
      @text_no_emoji += ' ' unless @prev_space
      @text_no_emoji += @emoji_dictionary[emoji]
      @prev_space = false
    end

    def handle_simple_character(character)
      @text_no_emoji += character
      @prev_space = character == ' '
    end
  end
end
