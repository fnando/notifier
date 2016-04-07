require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"
require "notifier"
require "minitest/utils"
require "minitest/autorun"

module Snarl
  def self.show_message(*)
  end
end
