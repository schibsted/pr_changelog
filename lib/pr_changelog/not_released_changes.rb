# frozen_string_literal: true

module PrChangelog
  # Calculates a list of not released changes from `base_ref` to `current_ref`
  # those changes consist of the merged pull-request title
  class NotReleasedChanges
    GITHUB_MERGE_COMMIT_FORMAT = /Merge pull request (?<pr_number>#\d+) .*/.freeze
    MERGE_BRANCH_COMMIT_FORMAT = /(Merge branch '.*'\s?(into|of)? .*)|(Merge .* branch .*)/.freeze
    PARSED_MERGE_COMMIT_FORMAT = /^- #(?<pr_number>\d+):\s+(?<tag>[^\s]+):\s*(?<title>.*)$/.freeze

    attr_reader :base_ref, :current_ref, :git_proxy

    def initialize(base_ref, current_ref, git_proxy = GitProxy.new)
      @base_ref    = base_ref
      @current_ref = current_ref
      @git_proxy   = git_proxy
    end

    Tag = Struct.new(:emoji, :title, :sort)

    EMOJI_TAGS = {
      'feature' => Tag.new('⭐️', 'New features', 0),
      'fix' => Tag.new('🐛', 'Fixes', 1),
      'improvement' => Tag.new('💎', 'Improvements', 2),
      'internal' => Tag.new('👨‍💻', 'Internal', 4),
      'unclassified' => Tag.new('❓', 'Unclassified', 5)
    }.freeze

    def formatted_changelog
      if formatted_change_list.positive?
        formatted_change_list.join("\n")
      else
        "There are no changes since #{base_ref} to #{current_ref}"
      end
    end

    def grouped_formatted_changelog
      changes = formatted_change_list
      if changes.count.positive?

        grouped_changes = changes.group_by do |change_line|
          EMOJI_TAGS[tag_from(change_line)] || EMOJI_TAGS['unclassified']
        end

        sorted_hash = grouped_changes.sort do |first_pair, second_pair|
          first_pair[0].sort <=> second_pair[0].sort
        end

        new_hash = {}
        sorted_hash.each do |tag, change_lines|
          new_key = "[#{tag.title}]"
          new_hash[new_key] = change_lines.map do |change_line|
            emojify_tag_for(change_line)
          end
        end

        new_hash.reduce('') do |string, pair|
          tag   = pair[0]
          lines = pair[1].map { |l| "  #{l}" }.join("\n")
          string + "#{tag}\n#{lines}\n\n"
        end.chomp
      else
        "There are no changes since #{base_ref} to #{current_ref}"
      end
    end

    def formatted_change_list
      parsed_merge_commits.map do |pair|
        format_merge_commit(pair.first, pair.last)
      end
    end

    private

    def first_uppercase(line)
      return line unless line.length > 2

      "#{line[0].upcase}#{line[1, line.length]}"
    end

    def emojify_tag_for(change_line)
      match = change_line.match(PARSED_MERGE_COMMIT_FORMAT)
      return change_line unless match

      emoji_tag = EMOJI_TAGS[match[:tag].downcase].emoji || '❓'
      "- ##{match[:pr_number]}: #{emoji_tag} #{first_uppercase(match[:title])}"
    end

    def tag_from(merge_commit)
      match = merge_commit.match(PARSED_MERGE_COMMIT_FORMAT)
      return nil unless match

      match[:tag].downcase
    end

    def parsed_merge_commits
      merge_commits_not_merged_into_base_ref
        .split('- ')
        .reject(&:empty?)
        .reject { |line| line.match(MERGE_BRANCH_COMMIT_FORMAT) }
        .map { |e| e.split("\n") }
    end

    def format_merge_commit(github_commit_title, commit_title)
      pr_number = pull_request_number_for(github_commit_title)

      "- #{pr_number}: #{commit_title.strip}"
    end

    def merge_commits_not_merged_into_base_ref
      git_proxy.merge_commits_between(base_ref, current_ref)
    end

    def pull_request_number_for(github_commit_title)
      md = github_commit_title.match(GITHUB_MERGE_COMMIT_FORMAT)
      md[:pr_number] if md
    end
  end
end
