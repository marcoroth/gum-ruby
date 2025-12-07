# frozen_string_literal: true

require_relative "lib/gum/version"

Gem::Specification.new do |spec|
  spec.name = "gum"
  spec.version = Gum::VERSION
  spec.authors = ["Marco Roth"]
  spec.email = ["marco.roth@intergga.ch"]

  spec.summary = "Ruby wrapper for Charm's gum CLI tool."
  spec.description = "Integrate Charm's gum with the RubyGems infrastructure."
  spec.homepage = "https://github.com/marcoroth/gum-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/marcoroth/gum-ruby",
    "changelog_uri" => "https://github.com/marcoroth/gum-ruby/releases",
    "rubygems_mfa_required" => "true",
  }

  spec.files = Dir[
    "gum.gemspec",
    "lib/**/*",
    "sig/**/*",
    "LICENSE.txt",
    "README.md"
  ]

  spec.bindir = "exe"
  spec.executables = ["gum"]
  spec.require_paths = ["lib"]
end
