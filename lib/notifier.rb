require "open3"
require "socket"
require "digest/md5"
require "timeout"
require "rbconfig"

module Notifier
  require "notifier/growl"
  require "notifier/gntp"
  require "notifier/snarl"
  require "notifier/osd_cat"
  require "notifier/knotify"
  require "notifier/kdialog"
  require "notifier/notify_send"
  require "notifier/placebo"
  require "notifier/terminal_notifier"
  require "notifier/version"
  require "notifier/adapters"

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
      const_get(name) unless %w[Placebo Adapters Version].include?(name.to_s)
    end.compact + [Placebo]
  end

  def supported_notifiers
    notifiers.select {|notifier| notifier.supported?}
  end

  def from_name(name)
    const_get(classify(name.to_s))
  rescue Exception
    nil
  end

  def supported_notifier_from_name(name)
    notifier = from_name(name)
    notifier && notifier.supported? ? notifier : nil
  end

  def os?(regex)
    RUBY_PLATFORM =~ regex || RbConfig::CONFIG["host_os"] =~ regex
  end

  private
  def classify(string)
    string.gsub(/_(.)/sm) { "#{$1.upcase}" }.gsub(/^(.)/) { "#{$1.upcase}" }
  end
end
