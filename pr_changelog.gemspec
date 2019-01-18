# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pr_changelog/version'

Gem::Specification.new do |spec|
  spec.name          = 'pr_changelog'
  spec.version       = PrChangelog::VERSION
  spec.authors       = ['Felipe Espinoza']
  spec.email         = ['felipe.espinoza@schibsted.com']

  spec.summary       = 'A script to generate nice changelogs from your merged PRs'
  spec.homepage      = 'https://github.com/fespinoza/pr_changelog'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
