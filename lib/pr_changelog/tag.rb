# frozen_string_literal: true

module PrChangelog
  # A way to classify particular change lines
  class Tag
    attr_reader :emoji, :title, :sort_index

    def initialize(emoji, title, sort_index)
      @emoji = emoji
      @title = title
      @sort_index = sort_index
    end

    def formatted_title
      "[#{title}]"
    end
  end
end
