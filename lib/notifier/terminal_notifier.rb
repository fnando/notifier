# frozen_string_literal: true

module Notifier
  module TerminalNotifier
    extend self

    def supported?
      Notifier.os?(/darwin/) && `which terminal-notifier` && $CHILD_STATUS == 0
    end

    def notify(options)
      command = [
        "terminal-notifier",
        "-group", "notifier-rubygems",
        "-title", options[:title].to_s,
        "-appIcon", options.fetch(:image, "").to_s,
        "-message", options[:message].to_s,
        "-subtitle", options.fetch(:subtitle, "").to_s
      ]

      # -sound with an empty string (e.g., "") will trigger the
      # default sound so we need to check for it.
      if options[:sound]
        command.concat([
          "-sound",
          options.fetch(:sound, "default").to_s
        ])
      end

      Thread.new do
        Open3.popen3(*command) do |_stdin, _stdout, _stderr|
          # noop
        end
      end.join
    end
  end
end
