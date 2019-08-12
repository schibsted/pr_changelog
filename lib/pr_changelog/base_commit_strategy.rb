# frozen_string_literal: true

module PrChangelog
  # Todo
  class BaseCommitStrategy
    def parsed_commits
      raise 'Not implemented'
    end

    def format_commit(_commit_line)
      raise 'Not implemented'
    end
  end
end
