require "notifier"

module SpecHelpers
  def unsupport_all_notifiers
    Notifier.notifiers.each do |notifier|
      notifier.stub :supported? => false unless notifier == Notifier::Placebo
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
