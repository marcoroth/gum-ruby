# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

require "shellwords"

module Gum
  # Display a spinner while running a command or block
  #
  # @example With shell command
  #   Gum.spin("Installing...", command: "npm install")
  #
  # @example With Ruby block
  #   result = Gum.spin("Processing...") do
  #     # long running operation
  #     expensive_computation
  #   end
  #
  # @example Custom spinner type
  #   Gum.spin("Loading...", spinner: :dot, command: "sleep 5")
  #
  class Spin
    SPINNERS = [
      :line, :dot, :minidot, :jump, :pulse, :points, :globe, :moon, :monkey, :meter, :hamburger
    ].freeze #: Array[Symbol]

    # Display a spinner while running a command or block
    #
    # @rbs title: String -- spinner title text (default: "Loading...")
    # @rbs command: String? -- shell command to execute
    # @rbs spinner: Symbol | String | nil -- spinner type (see SPINNERS constant)
    # @rbs show_output: bool? -- show command stdout after completion
    # @rbs show_error: bool? -- show command stderr after completion
    # @rbs align: Symbol? -- alignment of spinner and title (:left, :right)
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs spinner_style: Hash[Symbol, untyped]? -- spinner animation style
    # @rbs title_style: Hash[Symbol, untyped]? -- title text style
    # @rbs &block: ^() -> untyped | nil -- Ruby block to execute (alternative to command)
    # @rbs return: String | untyped | nil -- command output or block result, nil if cancelled
    def self.call(
      title = "Loading...",
      command: nil,
      spinner: nil,
      show_output: nil,
      show_error: nil,
      align: nil,
      timeout: nil,
      spinner_style: nil,
      title_style: nil,
      &block
    )
      raise ArgumentError, "Cannot specify both command and block" if block && command

      if block
        run_with_block(title, spinner: spinner, spinner_style: spinner_style, title_style: title_style, &block)
      else
        run_with_command(
          title,
          command: command,
          spinner: spinner,
          show_output: show_output,
          show_error: show_error,
          align: align,
          timeout: timeout,
          spinner_style: spinner_style,
          title_style: title_style
        )
      end
    end

    # @rbs title: String -- spinner title text
    # @rbs command: String -- shell command to execute
    # @rbs spinner: Symbol | String | nil -- spinner type
    # @rbs show_output: bool? -- show command stdout
    # @rbs show_error: bool? -- show command stderr
    # @rbs align: Symbol? -- alignment of spinner
    # @rbs timeout: Integer? -- timeout in seconds
    # @rbs spinner_style: Hash[Symbol, untyped]? -- spinner animation style
    # @rbs title_style: Hash[Symbol, untyped]? -- title text style
    # @rbs return: bool? -- true if command succeeded, false/nil otherwise
    def self.run_with_command(
      title,
      command:,
      spinner:,
      show_output:,
      show_error:,
      align:,
      timeout:,
      spinner_style:,
      title_style:
    )
      raise ArgumentError, "Command is required when not using a block" unless command

      options = {
        title: title,
        spinner: spinner&.to_s,
        "show-output": show_output,
        "show-error": show_error,
        align: align&.to_s,
        timeout: timeout ? "#{timeout}s" : nil,
      }

      args = Command.build_args("spin", **options.compact)

      Command.add_style_args(args, :spinner, spinner_style)
      Command.add_style_args(args, :title, title_style)

      args << "--"
      args.concat(command.shellsplit)

      system(Gum.executable, *args.map(&:to_s))
    end

    # @rbs title: String -- spinner title text
    # @rbs spinner: Symbol | String | nil -- spinner type
    # @rbs spinner_style: Hash[Symbol, untyped]? -- spinner animation style
    # @rbs title_style: Hash[Symbol, untyped]? -- title text style
    # @rbs &block: ^() -> untyped -- Ruby block to execute
    # @rbs return: untyped -- block result
    def self.run_with_block(
      title,
      spinner:,
      spinner_style:,
      title_style:,
      &block
    )
      require "fileutils"

      result = nil
      error = nil
      marker_path = "/tmp/gum_spin_done_#{Process.pid}_#{Time.now.to_i}"

      options = {
        title: title,
        spinner: spinner&.to_s,
      }

      args = Command.build_args("spin", **options.compact)

      Command.add_style_args(args, :spinner, spinner_style)
      Command.add_style_args(args, :title, title_style)

      args << "--"
      args.push("bash", "-c", "while [ ! -f #{marker_path} ]; do sleep 0.1; done")

      spinner_pid = Process.fork do
        exec(Gum.executable, *args.map(&:to_s))
      end

      begin
        result = block.call
      rescue StandardError => e
        error = e
      end

      FileUtils.touch(marker_path)
      Process.wait(spinner_pid)
      FileUtils.rm_f(marker_path)

      raise error if error

      result
    end

    private_class_method :run_with_command, :run_with_block
  end
end
