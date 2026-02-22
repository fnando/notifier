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
        "-ignoreDnD",
        "-group", "notifier-rubygems",
        "-title", options[:title].to_s,
        "-message", options[:message].to_s,
        "-subtitle", options.fetch(:subtitle, "").to_s
      ]

      # -sound with an empty string (e.g., "") will trigger the
      # default sound so we need to check for it.
      if options[:sound]
        command.push("-sound", options.fetch(:sound, "default").to_s)
      end

      Thread.new do
        Open3.popen3(*command) do |_stdin, _stdout, _stderr|
          # noop
        end

        sleep 5

        Open3.popen3("terminal-notifier", "-remove", "notifier-rubygems")
      end.join
    end
  end
end
