# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

require_relative "gum/version"
require_relative "gum/command"

module Gum
  autoload :Upstream, "gum/upstream"
  autoload :Choose, "gum/commands/choose"
  autoload :Confirm, "gum/commands/confirm"
  autoload :FilePicker, "gum/commands/file"
  autoload :Filter, "gum/commands/filter"
  autoload :Format, "gum/commands/format"
  autoload :Input, "gum/commands/input"
  autoload :Join, "gum/commands/join"
  autoload :Log, "gum/commands/log"
  autoload :Pager, "gum/commands/pager"
  autoload :Spin, "gum/commands/spin"
  autoload :Style, "gum/commands/style"
  autoload :Table, "gum/commands/table"
  autoload :Write, "gum/commands/write"

  GEM_NAME = "gum"
  DEFAULT_DIR = File.expand_path(File.join(__dir__, "..", "exe"))

  class Error < StandardError; end
  class ExecutableNotFoundException < Error; end
  class UnsupportedPlatformException < Error; end
  class DirectoryNotFoundException < Error; end

  class << self
    def execute(*args)
      system(executable, *args.map(&:to_s))
    end

    def platform
      [:cpu, :os].map { |m| Gem::Platform.local.public_send(m) }.join("-")
    end

    def version
      "gum v#{VERSION} (upstream v#{Upstream::VERSION}) [#{platform}]"
    end

    def executable(exe_path: DEFAULT_DIR)
      gum_install_dir = ENV.fetch("GUM_INSTALL_DIR", nil)

      if gum_install_dir
        raise DirectoryNotFoundException, <<~MESSAGE unless File.directory?(gum_install_dir)
          GUM_INSTALL_DIR is set to #{gum_install_dir}, but that directory does not exist.
        MESSAGE

        warn "NOTE: using GUM_INSTALL_DIR to find gum executable: #{gum_install_dir}"
        exe_file = File.expand_path(File.join(gum_install_dir, "gum"))
      else
        if Gum::Upstream::NATIVE_PLATFORMS.keys.none? { |p| Gem::Platform.match_gem?(Gem::Platform.new(p), GEM_NAME) }
          raise UnsupportedPlatformException, <<~MESSAGE
            gum does not support the #{platform} platform.
            Please install gum following instructions at https://github.com/charmbracelet/gum#installation
          MESSAGE
        end

        exe_file = Dir.glob(File.expand_path(File.join(exe_path, "**", "gum"))).find do |f|
          Gem::Platform.match_gem?(Gem::Platform.new(File.basename(File.dirname(f))), GEM_NAME)
        end
      end

      if exe_file.nil? || !File.exist?(exe_file)
        raise ExecutableNotFoundException, <<~MESSAGE
          Cannot find the gum executable for #{platform} in #{exe_path}

          If you're using bundler, please make sure you're on the latest bundler version:

              gem install bundler
              bundle update --bundler

          Then make sure your lock file includes this platform by running:

              bundle lock --add-platform #{platform}
              bundle install

          See `bundle lock --help` output for details.

          If you're still seeing this message after taking those steps, try running
          `bundle config` and ensure `force_ruby_platform` isn't set to `true`.
        MESSAGE
      end

      exe_file
    end

    # ─────────────────────────────────────────────────────────────────────────
    # High-level Ruby API
    # ─────────────────────────────────────────────────────────────────────────

    # Prompt for single-line input
    # @see Gum::Input#call
    def input(**)
      Input.call(**)
    end

    # Prompt for multi-line text input
    # @see Gum::Write#call
    def write(**)
      Write.call(**)
    end

    # Choose from a list of options
    # @see Gum::Choose#call
    def choose(...)
      Choose.call(...)
    end

    # Filter items with fuzzy matching
    # @see Gum::Filter#call
    def filter(...)
      Filter.call(...)
    end

    # Prompt for confirmation
    # @see Gum::Confirm#call
    def confirm(prompt = "Are you sure?", **)
      Confirm.call(prompt, **)
    end

    # Pick a file from the filesystem
    # @see Gum::FilePicker#call
    def file(path = nil, **)
      FilePicker.call(path, **)
    end

    # Display content in a scrollable pager
    # @see Gum::Pager#call
    def pager(content, **)
      Pager.call(content, **)
    end

    # Display a spinner while running a command or block
    # @see Gum::Spin#call
    def spin(title = "Loading...", **, &)
      Spin.call(title, **, &)
    end

    # Apply styling to text
    # @see Gum::Style#call
    def style(*text, **)
      Style.call(*text, **)
    end

    # Join text blocks together
    # @see Gum::Join#call
    def join(*texts, **)
      Join.call(*texts, **)
    end

    # Format text (markdown, code, template, emoji)
    # @see Gum::Format#call
    def format(*text, **)
      Format.call(*text, **)
    end

    # Display and select from tabular data
    # @see Gum::Table#call
    def table(data, **)
      Table.call(data, **)
    end

    # Log a message
    # @see Gum::Log#call
    def log(message, **)
      Log.call(message, **)
    end
  end
end
