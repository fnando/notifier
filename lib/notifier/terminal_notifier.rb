module Notifier
  module TerminalNotifier
    extend self

    def supported?
      Notifier.os?(/darwin/) && `which terminal-notifier` && $? == 0
    end

    def notify(options)
      register
      command = [
        "terminal-notifier",
        "-title", options[:title],
        "-appIcon", options.fetch(:image, ''),
        "-message", options[:message]
      ]

      Thread.new { system(*command) }
    end
  end
end
