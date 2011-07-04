module Notifier
  module Knotify
    extend self

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `ps -Al | grep dcop` && $? == 0
    end

    def notify(options)
      Thread.new do
          title = options[:title] || "Notification"
          message = options[:message] || "Message"
        # `dcop knotify default notify eventname \'#{options[:title]}\' \'#{options[:message]}\' '' '' 16 2`
          system("dcop", "knotify", "default", "notify", "eventname", title, message, '', '', "16", "2")
      end
    end
  end
end
