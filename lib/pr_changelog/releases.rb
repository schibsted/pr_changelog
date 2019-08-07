# frozen_string_literal: true

module PrChangelog
  class Releases
    attr_reader :git_proxy

    def initialize(git_proxy = GitProxy.new)
      @git_proxy = git_proxy
    end

    def last_release
      sorted_tags.last
    end

    def last_release_pair
      sorted_tags.last(2)
    end

    private

    def sorted_tags
      git_proxy.git_tags_list.sort_by { |tag| tag_value(tag) }
    end

    def tag_value(tag)
      components = tag.split('.')
      components[0].to_i * 100_000 + components[1].to_i * 1_000 + components[2].to_i
    end
  end
end
