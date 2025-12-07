# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Prompt for multi-line text input
  #
  # @example Basic multi-line input
  #   description = Gum.write(placeholder: "Enter description...")
  #
  # @example With dimensions
  #   notes = Gum.write(width: 80, height: 10, header: "Notes")
  #
  class Write
    # Prompt for multi-line text input (Ctrl+D to submit)
    #
    # @rbs placeholder: String? -- placeholder text shown when empty
    # @rbs prompt: String? -- prompt string shown at the start of each line
    # @rbs value: String? -- initial value for the text area
    # @rbs char_limit: Integer? -- maximum number of characters allowed
    # @rbs width: Integer? -- width of the text area
    # @rbs height: Integer? -- height of the text area in lines
    # @rbs header: String? -- header text displayed above the input
    # @rbs show_cursor_line: bool? -- highlight the line with the cursor
    # @rbs show_line_numbers: bool? -- display line numbers
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs cursor: Hash[Symbol, untyped]? -- cursor style options
    # @rbs cursor_line: Hash[Symbol, untyped]? -- cursor line highlight style
    # @rbs placeholder_style: Hash[Symbol, untyped]? -- placeholder text style
    # @rbs prompt_style: Hash[Symbol, untyped]? -- prompt text style
    # @rbs end_of_buffer: Hash[Symbol, untyped]? -- end of buffer character style
    # @rbs line_number: Hash[Symbol, untyped]? -- line number style
    # @rbs header_style: Hash[Symbol, untyped]? -- header text style
    # @rbs base: Hash[Symbol, untyped]? -- base text style
    # @rbs return: String? -- the entered text, or nil if cancelled
    def self.call(
      placeholder: nil,
      prompt: nil,
      value: nil,
      char_limit: nil,
      width: nil,
      height: nil,
      header: nil,
      show_cursor_line: nil,
      show_line_numbers: nil,
      timeout: nil,
      cursor: nil,
      cursor_line: nil,
      placeholder_style: nil,
      prompt_style: nil,
      end_of_buffer: nil,
      line_number: nil,
      header_style: nil,
      base: nil
    )
      options = {
        placeholder: placeholder,
        prompt: prompt,
        value: value,
        char_limit: char_limit,
        width: width,
        height: height,
        header: header,
        show_cursor_line: show_cursor_line,
        show_line_numbers: show_line_numbers,
        timeout: timeout ? "#{timeout}s" : nil,
        base: base,
      }

      options[:cursor] = cursor if cursor
      options[:cursor_line] = cursor_line if cursor_line
      options[:end_of_buffer] = end_of_buffer if end_of_buffer
      options[:line_number] = line_number if line_number

      args = Command.build_args("write", **options.compact)

      Command.add_style_args(args, :placeholder, placeholder_style)
      Command.add_style_args(args, :prompt, prompt_style)
      Command.add_style_args(args, :header, header_style)

      Command.run(*args)
    end
  end
end
