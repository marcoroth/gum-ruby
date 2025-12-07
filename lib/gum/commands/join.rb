# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  # Join text blocks horizontally or vertically
  #
  # @example Horizontal join (default)
  #   combined = Gum.join(box1, box2)
  #
  # @example Vertical join
  #   stacked = Gum.join(box1, box2, vertical: true)
  #
  # @example With alignment
  #   aligned = Gum.join(box1, box2, vertical: true, align: :center)
  #
  class Join
    # Join text blocks together
    #
    # @rbs *texts: String -- text blocks to join (usually styled with Gum.style)
    # @rbs vertical: bool -- stack blocks vertically (default: false, horizontal)
    # @rbs horizontal: bool -- place blocks side by side (default)
    # @rbs align: Symbol | String | nil -- alignment (:left, :center, :right for vertical; :top, :middle, :bottom for horizontal)
    # @rbs return: String? -- combined text output
    def self.call(*texts, vertical: false, horizontal: false, align: nil)
      options = {} #: Hash[Symbol, untyped]

      if vertical
        options[:vertical] = true
      elsif horizontal
        options[:horizontal] = true
      end

      options[:align] = align.to_s if align

      args = Command.build_args("join", *texts, **options.compact)

      Command.run(*args, interactive: false)
    end
  end
end
