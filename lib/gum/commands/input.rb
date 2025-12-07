# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Prompt for single-line input
  #
  # @example Basic input
  #   name = Gum.input(placeholder: "Enter your name")
  #
  # @example Password input
  #   password = Gum.input(password: true)
  #
  # @example With default value and custom prompt
  #   email = Gum.input(value: "user@", prompt: "> ", placeholder: "email")
  #
  class Input
    # Prompt for single-line input
    #
    # @rbs placeholder: String? -- placeholder text shown when input is empty
    # @rbs prompt: String? -- prompt string shown before input
    # @rbs value: String? -- initial value for the input
    # @rbs char_limit: Integer? -- maximum number of characters allowed
    # @rbs width: Integer? -- width of the input field
    # @rbs password: bool -- mask input characters for password entry
    # @rbs header: String? -- header text displayed above the input
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs cursor: Hash[Symbol, untyped]? -- cursor style options (foreground, background)
    # @rbs prompt_style: Hash[Symbol, untyped]? -- prompt text style options
    # @rbs placeholder_style: Hash[Symbol, untyped]? -- placeholder text style options
    # @rbs header_style: Hash[Symbol, untyped]? -- header text style options
    # @rbs return: String? -- the entered text, or nil if cancelled
    def self.call(
      placeholder: nil,
      prompt: nil,
      value: nil,
      char_limit: nil,
      width: nil,
      password: false,
      header: nil,
      timeout: nil,
      cursor: nil,
      prompt_style: nil,
      placeholder_style: nil,
      header_style: nil
    )
      options = {
        placeholder: placeholder,
        prompt: prompt,
        value: value,
        char_limit: char_limit,
        width: width,
        password: password || nil,
        header: header,
        timeout: timeout ? "#{timeout}s" : nil,
        cursor: cursor,
      }

      args = Command.build_args("input", **options.compact)

      Command.add_style_args(args, :prompt, prompt_style)
      Command.add_style_args(args, :placeholder, placeholder_style)
      Command.add_style_args(args, :header, header_style)

      Command.run(*args)
    end
  end
end
