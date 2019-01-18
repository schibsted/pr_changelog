# frozen_string_literal: true

module PrChangelog
  # A class to group change lines by tag
  class GroupedChanges
    attr_reader :changes, :tags

    def initialize(changes, tags)
      @changes = changes
      @tags = tags
    end

    def to_s
      new_hash = {}
      grouped_changes.each do |tag, change_lines|
        new_key = tag.formatted_title
        new_hash[new_key] = change_lines.map do |change_line|
          change_line.emojified_for(tag)
        end
      end

      new_hash.reduce('') do |string, pair|
        tag   = pair[0]
        lines = pair[1].map { |l| "  #{l}" }.join("\n")
        string + "#{tag}\n#{lines}\n\n"
      end.strip.chomp
    end

    private

    def grouped_changes
      @grouped_changes ||= changes.group_by do |change_line|
        tags[change_line&.tag&.downcase] || tags['unclassified']
      end.sort do |first_group, second_group|
        first_group[0].sort_index <=> second_group[0].sort_index
      end
    end
  end
end
