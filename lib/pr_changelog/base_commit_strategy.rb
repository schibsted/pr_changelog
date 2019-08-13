# frozen_string_literal: true

module PrChangelog
  # A "protocol"-like base class for the extracting the change commit strategies
  class BaseCommitStrategy
    def parsed_commits
      raise 'Not implemented'
    end

    def format_commit(_commit_line)
      raise 'Not implemented'
    end
  end
end
