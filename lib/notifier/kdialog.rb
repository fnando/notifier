# frozen_string_literal: true

module Notifier
  module Kdialog
    extend self

    def supported?
      Notifier.os?(/(linux|freebsd)/) &&
        `which kdialog > /dev/null` &&
        $CHILD_STATUS == 0
    end

    def notify(options)
      command = [
        "kdialog",
        "--title", options[:title].to_s,
        "--passivepopup", options[:message].to_s,
        "5"
      ]

      Thread.new { system(*command) }.join
    end
  end
end
