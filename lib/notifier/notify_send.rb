module Notifier
  module NotifySend
    extend self

    def supported?
      Notifier.os?(/(linux|freebsd)/) && `which notify-send &> /dev/null` && $? == 0
    end

    def notify(options)
      command = [
        "notify-send", "-i",
        options[:image].to_s,
        options[:title].to_s,
        options[:message].to_s
      ]

      Thread.new { system(*command) }.join
    end
  end
end
