gem "test-unit"
require "test/unit"
require "mocha"

require "notifier"

class Test::Unit::TestCase
  private
  def unsupport_all_notifiers
    Notifier.notifiers.each do |notifier|
      notifier.stubs(:supported?).returns(false) unless notifier == Notifier::Placebo
    end
  end
end
