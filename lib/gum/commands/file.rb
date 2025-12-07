# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Pick a file from a folder
  #
  # @example Basic file picker
  #   path = Gum.file
  #
  # @example Start from specific directory
  #   path = Gum.file(directory: "~/Documents")
  #
  # @example Show hidden files
  #   path = Gum.file(all: true)
  #
  # @example Only show directories
  #   dir = Gum.file(directory_only: true)
  #
  class FilePicker
    # Pick a file from the filesystem
    #
    # @rbs path: String? -- starting directory path
    # @rbs cursor: String? -- cursor character
    # @rbs all: bool? -- show hidden files and directories
    # @rbs file: bool? -- allow file selection (default: true)
    # @rbs directory: bool? -- allow directory selection (default: false)
    # @rbs directory_only: bool -- only allow directory selection (convenience option)
    # @rbs height: Integer? -- height of the file picker
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs cursor_style: Hash[Symbol, untyped]? -- cursor style options
    # @rbs symlink_style: Hash[Symbol, untyped]? -- symlink text style
    # @rbs directory_style: Hash[Symbol, untyped]? -- directory text style
    # @rbs file_style: Hash[Symbol, untyped]? -- file text style
    # @rbs permissions_style: Hash[Symbol, untyped]? -- permissions text style
    # @rbs selected_style: Hash[Symbol, untyped]? -- selected item style
    # @rbs file_size_style: Hash[Symbol, untyped]? -- file size text style
    # @rbs return: String? -- selected file path, or nil if cancelled
    def self.call(
      path = nil,
      cursor: nil,
      all: nil,
      file: nil,
      directory: nil,
      directory_only: false,
      height: nil,
      timeout: nil,
      cursor_style: nil,
      symlink_style: nil,
      directory_style: nil,
      file_style: nil,
      permissions_style: nil,
      selected_style: nil,
      file_size_style: nil
    )
      if directory_only
        file = false
        directory = true
      end

      options = {
        cursor: cursor,
        all: all,
        file: file,
        directory: directory,
        height: height,
        timeout: timeout ? "#{timeout}s" : nil,
      }

      positional = path ? [path] : [] #: Array[String]
      args = Command.build_args("file", *positional, **options.compact)

      Command.add_style_args(args, :cursor, cursor_style)
      Command.add_style_args(args, :symlink, symlink_style)
      Command.add_style_args(args, :directory, directory_style)
      Command.add_style_args(args, :file, file_style)
      Command.add_style_args(args, :permissions, permissions_style)
      Command.add_style_args(args, :selected, selected_style)
      Command.add_style_args(args, :"file-size", file_size_style)

      Command.run(*args)
    end
  end
end
