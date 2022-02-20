# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "notifier"
require "minitest/utils"
require "minitest/autorun"

module Snarl
  def self.show_message(*)
  end
end
