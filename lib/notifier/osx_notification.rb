require 'rubygems'
require 'terminal-notifier'

module Notifier
  module OsxNotification
    extend self

    def supported?
      return false unless Notifier.os?(/darwin/)

      if match = `sw_vers`.match(/ProductVersion:\t(?<maj>\d+)\.(?<min>\d+)/)
        major, minor = match[:maj].to_i, match[:min].to_i

        if (major == 10 && minor < 8)
          return false
        else
          return true
        end
      else
        false
      end
    end

    def notify(options)
      TerminalNotifier.notify(options[:message],
        :title    => 'Test Notifier',
        :activate => 'com.apple.Terminal',
        :group    => Process.pid)
    end
  end
end
