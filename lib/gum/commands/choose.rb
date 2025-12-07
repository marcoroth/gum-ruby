# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Choose an option from a list of choices
  #
  # @example Single selection with array
  #   color = Gum.choose(%w[red green blue])
  #
  # @example Single selection with splat
  #   color = Gum.choose("red", "green", "blue")
  #
  # @example Multiple selection
  #   colors = Gum.choose(%w[red green blue], limit: 2)
  #
  # @example Unlimited selection
  #   colors = Gum.choose(%w[red green blue], no_limit: true)
  #
  # @example With header and custom height
  #   choice = Gum.choose(options, header: "Pick one:", height: 10)
  #
  class Choose
    # Choose from a list of options
    #
    # @rbs *items: Array[String] | String -- list of choices to display (array or splat)
    # @rbs limit: Integer? -- maximum number of items that can be selected (1 = single select)
    # @rbs no_limit: bool -- allow unlimited selections (use tab/ctrl+space to select)
    # @rbs ordered: bool? -- maintain selection order
    # @rbs height: Integer? -- height of the list
    # @rbs cursor: String? -- cursor character (default: ">")
    # @rbs header: String? -- header text displayed above choices
    # @rbs cursor_prefix: String? -- prefix for the cursor line
    # @rbs selected_prefix: String? -- prefix for selected items (default: "✓")
    # @rbs unselected_prefix: String? -- prefix for unselected items (default: "○")
    # @rbs selected: Array[String]? -- items to pre-select
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs cursor_style: Hash[Symbol, untyped]? -- cursor style options
    # @rbs header_style: Hash[Symbol, untyped]? -- header text style
    # @rbs item_style: Hash[Symbol, untyped]? -- item text style
    # @rbs selected_style: Hash[Symbol, untyped]? -- selected item style
    # @rbs return: String | Array[String] | nil -- selected item(s), or nil if cancelled
    def self.call(
      *items,
      limit: nil,
      no_limit: false,
      ordered: nil,
      height: nil,
      cursor: nil,
      header: nil,
      cursor_prefix: nil,
      selected_prefix: nil,
      unselected_prefix: nil,
      selected: nil,
      timeout: nil,
      cursor_style: nil,
      header_style: nil,
      item_style: nil,
      selected_style: nil
    )
      items = items.flatten

      options = {
        limit: no_limit ? nil : limit,
        "no-limit": no_limit || nil,
        ordered: ordered,
        height: height,
        cursor: cursor,
        header: header,
        "cursor-prefix": cursor_prefix,
        "selected-prefix": selected_prefix,
        "unselected-prefix": unselected_prefix,
        timeout: timeout ? "#{timeout}s" : nil,
        item: item_style,
        selected: selected,
      }

      args = Command.build_args("choose", *items, **options.compact)

      Command.add_style_args(args, :cursor, cursor_style)
      Command.add_style_args(args, :header, header_style)
      Command.add_style_args(args, :selected, selected_style)

      result = Command.run(*args)

      return nil if result.nil?

      if no_limit || (limit && limit > 1)
        result.split("\n")
      else
        result
      end
    end
  end
end
