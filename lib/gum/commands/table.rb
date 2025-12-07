# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Display and select from tabular data
  #
  # @example From array of arrays
  #   selection = Gum.table([["Alice", 30], ["Bob", 25]], columns: %w[Name Age])
  #
  # @example From CSV string
  #   Gum.table(File.read("data.csv"))
  #
  # @example With custom separator
  #   Gum.table(data, separator: "\t")
  #
  class Table
    # Display tabular data and optionally allow row selection
    #
    # @rbs data: String | Array[Array[untyped]] -- CSV string or array of row arrays
    # @rbs columns: Array[String]? -- column headers (required when data is array)
    # @rbs separator: String? -- column separator (default: ",")
    # @rbs widths: Array[Integer]? -- column widths
    # @rbs height: Integer? -- table height in rows
    # @rbs print: bool? -- print table without selection (non-interactive)
    # @rbs border: Symbol | String | nil -- border style (:rounded, :thick, :normal, :hidden, :double, :none)
    # @rbs border_foreground: String | Integer | nil -- border color
    # @rbs border_background: String | Integer | nil -- border background color
    # @rbs cell_foreground: String | Integer | nil -- cell text color
    # @rbs cell_background: String | Integer | nil -- cell background color
    # @rbs header_foreground: String | Integer | nil -- header text color
    # @rbs header_background: String | Integer | nil -- header background color
    # @rbs selected_foreground: String | Integer | nil -- selected row text color
    # @rbs selected_background: String | Integer | nil -- selected row background color
    # @rbs return: String? -- selected row data, or nil if cancelled
    def self.call(
      data,
      columns: nil,
      separator: nil,
      widths: nil,
      height: nil,
      print: nil,
      border: nil,
      border_foreground: nil,
      border_background: nil,
      cell_foreground: nil,
      cell_background: nil,
      header_foreground: nil,
      header_background: nil,
      selected_foreground: nil,
      selected_background: nil
    )
      separator ||= ","

      csv_data = if data.is_a?(Array)
                   rows = [] #: Array[String]
                   rows << columns.join(separator) if columns
                   rows.concat(data.map { |row| row.join(separator) })
                   rows.join("\n")
                 else
                   data.to_s
                 end

      options = {
        separator: separator,
        widths: widths&.join(","),
        height: height,
        print: print,
        border: border&.to_s,
        "border.foreground": border_foreground&.to_s,
        "border.background": border_background&.to_s,
        "cell.foreground": cell_foreground&.to_s,
        "cell.background": cell_background&.to_s,
        "header.foreground": header_foreground&.to_s,
        "header.background": header_background&.to_s,
        "selected.foreground": selected_foreground&.to_s,
        "selected.background": selected_background&.to_s,
      }

      args = Command.build_args("table", **options.compact)

      if print
        IO.popen([Gum.executable, *args.map(&:to_s)], "w") do |io|
          io.write(csv_data)
        end

        nil
      else
        Command.run(*args, input: csv_data, interactive: true)
      end
    end
  end
end
