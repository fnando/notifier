module Notifier
  module TerminalNotifier
    extend self

    def supported?
      Notifier.os?(/darwin/) && `which terminal-notifier` && $? == 0
    end

    def notify(options)
      command = [
        "terminal-notifier",
        "-group", "notifier-rubygems",
        "-title", options[:title].to_s,
        "-appIcon", options.fetch(:image, "").to_s,
        "-message", options[:message].to_s,
        "-sound", options.fetch(:sound, "default").to_s
      ]

      Thread.new { system(*command) }.join
    end
  end
end
