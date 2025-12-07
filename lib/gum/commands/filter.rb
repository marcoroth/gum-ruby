# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Filter items from a list with fuzzy matching
  #
  # @example Single selection filter with array
  #   file = Gum.filter(Dir.glob("*"))
  #
  # @example Single selection filter with splat
  #   file = Gum.filter("file1.rb", "file2.rb", "file3.rb")
  #
  # @example Multiple selection filter
  #   files = Gum.filter(Dir.glob("*"), limit: 5)
  #
  # @example With placeholder and height
  #   selection = Gum.filter(items, placeholder: "Search...", height: 20)
  #
  class Filter
    # Filter a list with fuzzy matching
    #
    # @rbs *items: Array[String] | String -- list of items to filter (array or splat)
    # @rbs limit: Integer? -- maximum number of items that can be selected
    # @rbs no_limit: bool -- allow unlimited selections (use tab/ctrl+space to select)
    # @rbs height: Integer? -- height of the list
    # @rbs width: Integer? -- width of the filter input
    # @rbs placeholder: String? -- placeholder text for the filter input
    # @rbs prompt: String? -- prompt string shown before input
    # @rbs value: String? -- initial filter value
    # @rbs header: String? -- header text displayed above the list
    # @rbs indicator: String? -- character for selected item indicator
    # @rbs selected_prefix: String? -- prefix for selected items
    # @rbs unselected_prefix: String? -- prefix for unselected items
    # @rbs match_prefix: String? -- prefix for matched text
    # @rbs fuzzy: bool? -- enable fuzzy matching (default: true)
    # @rbs sort: bool? -- sort results by match score (default: true)
    # @rbs strict: bool? -- require exact match
    # @rbs reverse: bool? -- reverse the order of results
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs header_style: Hash[Symbol, untyped]? -- header text style
    # @rbs text_style: Hash[Symbol, untyped]? -- text style for items
    # @rbs cursor_text_style: Hash[Symbol, untyped]? -- style for cursor line text
    # @rbs match_style: Hash[Symbol, untyped]? -- style for matched characters
    # @rbs placeholder_style: Hash[Symbol, untyped]? -- placeholder text style
    # @rbs prompt_style: Hash[Symbol, untyped]? -- prompt text style
    # @rbs indicator_style: Hash[Symbol, untyped]? -- indicator character style
    # @rbs return: String | Array[String] | nil -- selected item(s), or nil if cancelled
    def self.call(
      *items,
      limit: nil,
      no_limit: false,
      height: nil,
      width: nil,
      placeholder: nil,
      prompt: nil,
      value: nil,
      header: nil,
      indicator: nil,
      selected_prefix: nil,
      unselected_prefix: nil,
      match_prefix: nil,
      fuzzy: nil,
      sort: nil,
      strict: nil,
      reverse: nil,
      timeout: nil,
      header_style: nil,
      text_style: nil,
      cursor_text_style: nil,
      match_style: nil,
      placeholder_style: nil,
      prompt_style: nil,
      indicator_style: nil
    )
      items = items.flatten

      options = {
        limit: no_limit ? 0 : limit,
        height: height,
        width: width,
        placeholder: placeholder,
        prompt: prompt,
        value: value,
        header: header,
        indicator: indicator,
        selected_prefix: selected_prefix,
        unselected_prefix: unselected_prefix,
        match_prefix: match_prefix,
        fuzzy: fuzzy,
        sort: sort,
        strict: strict,
        reverse: reverse,
        timeout: timeout ? "#{timeout}s" : nil,
        text: text_style,
        cursor_text: cursor_text_style,
        match: match_style,
      }

      args = Command.build_args("filter", **options.compact)

      Command.add_style_args(args, :header, header_style)
      Command.add_style_args(args, :placeholder, placeholder_style)
      Command.add_style_args(args, :prompt, prompt_style)
      Command.add_style_args(args, :indicator, indicator_style)

      input_data = items.join("\n")
      result = Command.run(*args, input: input_data)

      return nil if result.nil?

      if no_limit || (limit && limit > 1)
        result.split("\n")
      else
        result
      end
    end
  end
end
