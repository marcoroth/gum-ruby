# frozen_string_literal: true

require_relative "lib/gum/ruby/version"

Gem::Specification.new do |spec|
  spec.name = "gum-ruby"
  spec.version = Gum::Ruby::VERSION
  spec.authors = ["Marco Roth"]
  spec.email = ["marco.roth@intergga.ch"]

  spec.summary = "charm's gum for Ruby."
  spec.description = spec.summary
  spec.homepage = "https://github.com/marcoroth/gum-ruby"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/marcoroth/gum-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/marcoroth/gum-ruby/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir[
    "gem-ruby.gemspec",
    "LICENSE.txt",
    "Rakefile",
    "README.md",
    "lib/**/*.rb",
    "sig/**/*.rbs",
    "exe/*"
  ]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
