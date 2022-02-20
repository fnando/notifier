# frozen_string_literal: true

require "open3"
require "socket"
require "digest/md5"
require "timeout"
require "rbconfig"
require "English"

module Notifier
  require "notifier/snarl"
  require "notifier/osd_cat"
  require "notifier/knotify"
  require "notifier/kdialog"
  require "notifier/notify_send"
  require "notifier/placebo"
  require "notifier/terminal_notifier"
  require "notifier/version"

  extend self

  class << self
    attr_accessor :default_notifier
  end

  def skip_constants
    @skip_constants ||= %w[Placebo Adapters Version]
  end

  def notifier
    supported_notifier_from_name(default_notifier) || supported_notifiers.first
  end

  def notify(options)
    notifier.notify(options)
  end

  def notifiers
    constants.filter_map do |name|
      const_get(name) unless skip_constants.include?(name.to_s)
    end + [Placebo]
  end

  def supported_notifiers
    notifiers.select(&:supported?)
  end

  def from_name(name)
    const_get(classify(name.to_s))
  rescue StandardError
    nil
  end

  def supported_notifier_from_name(name)
    notifier = from_name(name)
    notifier&.supported? ? notifier : nil
  end

  def os?(regex)
    RUBY_PLATFORM =~ regex || RbConfig::CONFIG["host_os"] =~ regex
  end

  private def classify(string)
    string.gsub(/_(.)/sm) { Regexp.last_match(1).upcase.to_s }
          .gsub(/^(.)/) { Regexp.last_match(1).upcase.to_s }
  end
end
