# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Scroll through content in a pager
  #
  # @example View file content
  #   Gum.pager(File.read("README.md"))
  #
  # @example With line numbers
  #   Gum.pager(content, show_line_numbers: true)
  #
  # @example Soft wrap long lines
  #   Gum.pager(content, soft_wrap: true)
  #
  class Pager
    # Display content in a scrollable pager
    #
    # @rbs content: String -- content to display in the pager
    # @rbs show_line_numbers: bool? -- display line numbers
    # @rbs soft_wrap: bool? -- wrap long lines instead of horizontal scrolling
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs help_style: Hash[Symbol, untyped]? -- help text style
    # @rbs line_number_style: Hash[Symbol, untyped]? -- line number style
    # @rbs match_style: Hash[Symbol, untyped]? -- search match style
    # @rbs match_highlight_style: Hash[Symbol, untyped]? -- current search match highlight style
    # @rbs return: void
    def self.call(
      content,
      show_line_numbers: nil,
      soft_wrap: nil,
      timeout: nil,
      help_style: nil,
      line_number_style: nil,
      match_style: nil,
      match_highlight_style: nil
    )
      options = {
        "show-line-numbers": show_line_numbers,
        "soft-wrap": soft_wrap,
        timeout: timeout ? "#{timeout}s" : nil,
      }

      args = Command.build_args("pager", **options.compact)

      Command.add_style_args(args, :help, help_style)
      Command.add_style_args(args, :"line-number", line_number_style)
      Command.add_style_args(args, :match, match_style)
      Command.add_style_args(args, :"match-highlight", match_highlight_style)

      Command.run_display_only(*args, input: content)
    end
  end
end
