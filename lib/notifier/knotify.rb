# frozen_string_literal: true

module Notifier
  module Knotify
    extend self

    def supported?
      Notifier.os?(/(linux|freebsd)/) &&
        `ps -Al | grep dcop` &&
        $CHILD_STATUS == 0
    end

    def notify(options)
      command = [
        "dcop", "knotify", "default", "notify", "eventname",
        options[:title].to_s, options[:message].to_s,
        "", "", "16", "2"
      ]

      Thread.new { system(*command) }.join
    end
  end
end
