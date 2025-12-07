# frozen_string_literal: true

require_relative "test_helper"

module Gum
  class TestRuby < Minitest::Spec
    it "it has a verison number" do
      refute_nil ::Gum::Ruby::VERSION
    end
  end
end
