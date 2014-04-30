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
        "-title", options[:title],
        "-appIcon", options.fetch(:image, ""),
        "-message", options[:message]
      ]

      Thread.new { system(*command) }
    end
  end
end
