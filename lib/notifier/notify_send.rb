module Notifier
  module NotifySend
    extend self

    def supported?
      Notifier.os?(/(linux|freebsd)/) && `which notify-send > /dev/null` && $? == 0
    end

    def notify(options)
      command = [
        "notify-send", "-i",
        options[:image],
        options[:title],
        options[:message]
      ]

      Thread.new { system(*command) }
    end
  end
end
