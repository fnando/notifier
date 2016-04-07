require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"
require "notifier"
require "minitest/utils"
require "minitest/autorun"

module Minitest
  class Test
    def unsupport_all_notifiers
      Notifier.notifiers.each do |notifier|
        notifier.stubs(:supported?).returns(false) unless notifier == Notifier::Placebo
      end
    end
  end
end
