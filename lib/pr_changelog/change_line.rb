# frozen_string_literal: true

module PrChangelog
  # Represents a single change entry in the changelog
  class ChangeLine
    attr_reader :pr_number, :tag, :title

    def initialize(pr_number, tag, title)
      @pr_number = pr_number
      @tag = tag
      @title = title
    end

    def to_s
      if tag.nil?
        "- #{pr_number}: #{title.first_lowercase}"
      else
        "- #{pr_number}: #{tag}: #{title.first_lowercase}"
      end
    end

    def formatted_title
      title.first_uppercase
    end

    def emojified_for(tag_object)
      "- #{pr_number}: #{tag_object.emoji} #{formatted_title}"
    end
  end
end
