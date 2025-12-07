# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Format text with markdown, code highlighting, templates, or emojis
  #
  # @example Markdown formatting
  #   Gum.format("# Hello\n- Item 1\n- Item 2")
  #
  # @example Code highlighting
  #   Gum.format(code, type: :code, language: "ruby")
  #
  # @example Template formatting
  #   Gum.format('{{ Bold "Hello" }} {{ Color "99" "0" " World " }}', type: :template)
  #
  # @example Emoji formatting
  #   Gum.format("I :heart: Ruby :gem:", type: :emoji)
  #
  class Format
    TYPES = [:markdown, :code, :template, :emoji].freeze #: Array[Symbol]

    # Format and render text
    #
    # @rbs *text: String -- text content to format (multiple strings joined with newlines)
    # @rbs type: Symbol | String | nil -- format type (:markdown, :code, :template, :emoji)
    # @rbs language: String? -- programming language for code highlighting
    # @rbs theme: String? -- syntax highlighting theme
    # @rbs return: String? -- formatted text output
    def self.call(*text, type: nil, language: nil, theme: nil)
      options = {
        type: type&.to_s,
        language: language,
        theme: theme,
      }

      content = text.join("\n")

      args = Command.build_args("format", **options.compact)

      if content.empty?
        Command.run(*args, interactive: false)
      else
        Command.run(*args, input: content, interactive: false)
      end
    end

    # @rbs text: String -- markdown text to format
    # @rbs return: String? -- rendered markdown output
    def self.markdown(text)
      call(text, type: :markdown)
    end

    # @rbs text: String -- source code to highlight
    # @rbs language: String? -- programming language for highlighting
    # @rbs theme: String? -- syntax highlighting theme
    # @rbs return: String? -- syntax-highlighted code output
    def self.code(text, language: nil, theme: nil)
      call(text, type: :code, language: language, theme: theme)
    end

    # @rbs text: String -- template string with Termenv helpers
    # @rbs return: String? -- rendered template output
    def self.template(text)
      call(text, type: :template)
    end

    # @rbs text: String -- text with :emoji_name: codes
    # @rbs return: String? -- text with emojis rendered
    def self.emoji(text)
      call(text, type: :emoji)
    end
  end
end
