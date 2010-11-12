module Notifier
  module NotifySend
    extend self

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `which notify-send > /dev/null` && $? == 0
    end

    def notify(options)
      Thread.new do
        `notify-send -i #{options[:image]} #{options[:title]} \"#{options[:message]}\"`
      end
    end
  end
end
