# frozen_string_literal: true

require_relative "test_helper"

module Gum
  class GumTest < Minitest::Spec
    it "has a version number" do
      refute_nil ::Gum::VERSION
    end

    it "has an upstream version" do
      refute_nil ::Gum::Upstream::VERSION
      assert_match(/\d+\.\d+\.\d+/, ::Gum::Upstream::VERSION)
    end

    it "returns version info string" do
      version = Gum.version
      assert_includes version, "gum"
      assert_includes version, Gum::VERSION
      assert_includes version, Gum::Upstream::VERSION
    end

    it "returns platform string" do
      platform = Gum.platform
      refute_nil platform
      assert_kind_of String, platform
    end
  end
end
