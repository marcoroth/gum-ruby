# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Ask for user confirmation
  #
  # @example Basic confirmation
  #   if Gum.confirm("Delete file?")
  #     File.delete(path)
  #   end
  #
  # @example With default value
  #   proceed = Gum.confirm("Continue?", default: true)
  #
  # @example With custom button labels
  #   Gum.confirm("Save changes?", affirmative: "Save", negative: "Discard")
  #
  class Confirm
    # Prompt for yes/no confirmation
    #
    # @rbs prompt: String -- the confirmation prompt
    # @rbs default: bool? -- default value (true = yes, false = no)
    # @rbs affirmative: String? -- text for affirmative button (default: "Yes")
    # @rbs negative: String? -- text for negative button (default: "No")
    # @rbs timeout: Integer? -- timeout in seconds (0 = no timeout)
    # @rbs prompt_style: Hash[Symbol, untyped]? -- prompt text style options
    # @rbs selected_style: Hash[Symbol, untyped]? -- selected button style options
    # @rbs unselected_style: Hash[Symbol, untyped]? -- unselected button style options
    # @rbs return: bool -- true if confirmed, false if rejected
    def self.call(
      prompt = "Are you sure?",
      default: nil,
      affirmative: nil,
      negative: nil,
      timeout: nil,
      prompt_style: nil,
      selected_style: nil,
      unselected_style: nil
    )
      options = {
        default: default.nil? ? nil : default,
        affirmative: affirmative,
        negative: negative,
        timeout: timeout ? "#{timeout}s" : nil,
      }

      args = Command.build_args("confirm", prompt, **options.compact)

      Command.add_style_args(args, :prompt, prompt_style)
      Command.add_style_args(args, :selected, selected_style)
      Command.add_style_args(args, :unselected, unselected_style)

      Command.run_with_status(*args)
    end
  end
end
