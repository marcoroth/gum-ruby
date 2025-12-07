# frozen_string_literal: true
# typed: true
# rbs_inline: enabled

module Gum
  module Upstream
    VERSION = "0.17.0"

    NATIVE_PLATFORMS = {
      "arm64-darwin" => "gum_#{VERSION}_Darwin_arm64.tar.gz",
      "x86_64-darwin" => "gum_#{VERSION}_Darwin_x86_64.tar.gz",
      "arm64-linux" => "gum_#{VERSION}_Linux_arm64.tar.gz",
      "aarch64-linux" => "gum_#{VERSION}_Linux_arm64.tar.gz",
      "x86_64-linux" => "gum_#{VERSION}_Linux_x86_64.tar.gz",
    }.freeze
  end
end
