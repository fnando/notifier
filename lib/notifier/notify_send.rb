module Notifier
  module NotifySend
    extend self

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `which notify-send > /dev/null` && $? == 0
    end

    def notify(options)
      Thread.new do
          args = []
          args += ["-i", options[:image]] if options[:image]
          title = options[:title] || "Notification"
          message = options[:message] || "Message"
          args += [title, message]
          system('notify-send', *args)
      end
    end
  end
end
