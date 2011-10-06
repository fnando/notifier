require "open3"

module Notifier
  autoload :Growl,      "notifier/growl"
  autoload :Snarl,      "notifier/snarl"
  autoload :OsdCat,     "notifier/osd_cat"
  autoload :Knotify,    "notifier/knotify"
  autoload :Kdialog,    "notifier/kdialog"
  autoload :NotifySend, "notifier/notify_send"
  autoload :Placebo,    "notifier/placebo"
  autoload :Version,    "notifier/version"

  extend self

  class << self
    attr_accessor :default_notifier
  end

  def notifier
    supported_notifier_from_name(default_notifier) || supported_notifiers.first
  end

  def notify(options)
    notifier.notify(options)
  end

  def notifiers
    constants.collect do |name|
      const_get(name) unless %w[Placebo Version].include?(name.to_s)
    end.compact + [Placebo]
  end

  def supported_notifiers
    notifiers.select {|notifier| notifier.supported?}
  end

  def from_name(name)
    notifier = const_get(classify(name.to_s))
  rescue Exception
    nil
  end

  def supported_notifier_from_name(name)
    notifier = from_name(name)
    notifier && notifier.supported? ? notifier : nil
  end

  private
  def classify(string)
    string.gsub(/_(.)/sm) { "#{$1.upcase}" }.gsub(/^(.)/) { "#{$1.upcase}" }
  end
end
