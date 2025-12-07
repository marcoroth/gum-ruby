# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Apply styling to text
  #
  # @example Basic styling
  #   styled = Gum.style("Hello", foreground: "212", bold: true)
  #
  # @example With border
  #   box = Gum.style("Content", border: :double, padding: "1 2")
  #
  # @example Multiple lines
  #   styled = Gum.style("Line 1", "Line 2", align: :center, width: 50)
  #
  class Style
    BORDERS = [:none, :hidden, :rounded, :double, :thick, :normal].freeze #: Array[Symbol]
    ALIGNMENTS = [:left, :center, :right, :top, :middle, :bottom].freeze #: Array[Symbol]

    # Apply styling to text
    #
    # @rbs *text: String -- text content to style (multiple strings become separate lines)
    # @rbs foreground: String | Integer | nil -- text color (ANSI code, hex, or color name)
    # @rbs background: String | Integer | nil -- background color (ANSI code, hex, or color name)
    # @rbs border: Symbol | String | nil -- border style (:none, :hidden, :rounded, :double, :thick, :normal)
    # @rbs border_foreground: String | Integer | nil -- border color
    # @rbs border_background: String | Integer | nil -- border background color
    # @rbs align: Symbol | String | nil -- text alignment (:left, :center, :right)
    # @rbs height: Integer? -- fixed height in lines
    # @rbs width: Integer? -- fixed width in characters
    # @rbs margin: String | Array[Integer] | nil -- margin around the box ("1" or "1 2" or [1, 2, 1, 2])
    # @rbs padding: String | Array[Integer] | nil -- padding inside the box ("1" or "1 2" or [1, 2, 1, 2])
    # @rbs bold: bool? -- bold text
    # @rbs italic: bool? -- italic text
    # @rbs strikethrough: bool? -- strikethrough text
    # @rbs underline: bool? -- underlined text
    # @rbs faint: bool? -- faint/dim text
    # @rbs return: String? -- styled text output
    def self.call(
      *text,
      foreground: nil,
      background: nil,
      border: nil,
      border_foreground: nil,
      border_background: nil,
      align: nil,
      height: nil,
      width: nil,
      margin: nil,
      padding: nil,
      bold: nil,
      italic: nil,
      strikethrough: nil,
      underline: nil,
      faint: nil
    )
      options = {
        foreground: foreground&.to_s,
        background: background&.to_s,
        border: border&.to_s,
        "border-foreground": border_foreground&.to_s,
        "border-background": border_background&.to_s,
        align: align&.to_s,
        height: height,
        width: width,
        margin: format_spacing(margin),
        padding: format_spacing(padding),
        bold: bold,
        italic: italic,
        strikethrough: strikethrough,
        underline: underline,
        faint: faint,
      }

      args = Command.build_args("style", *text, **options.compact)
      Command.run(*args, interactive: false)
    end

    # @rbs value: String | Integer | Array[Integer] | nil -- spacing value to format
    # @rbs return: String? -- formatted spacing string
    def self.format_spacing(value)
      case value
      when Array
        value.join(" ")
      when String, Integer
        value.to_s
      end
    end

    private_class_method :format_spacing
  end
end
