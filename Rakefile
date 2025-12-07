# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rubocop/rake_task"

Minitest::TestTask.create
RuboCop::RakeTask.new

task :rbs_inline do
  require "open3"

  command = "bundle exec rbs-inline --opt-out --output=sig/ lib/"

  _stdout, stderr, status = Open3.capture3(command)

  puts "Running `#{command}`"

  if stderr.strip == "🎉 Generated 0 RBS files under sig/"
    puts "RBS files in sig/ are up to date"
    exit status.exitstatus
  else
    puts "RBS files in sig/ are not up to date"
    exit 1
  end
end

task default: [:test, :rubocop]
