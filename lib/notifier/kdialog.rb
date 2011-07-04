module Notifier
  module Kdialog
    extend self

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `which kdialog > /dev/null` && $? == 0
    end

    def notify(options)


      Thread.new { 
          args = []
          title = options[:title] || "Notification"
          message = options[:message] || "Message"
          args += ['--title', title]
          args += ['--passivepopup', message]
          args << "5"
          system("kdialog", *args)
      }
    end
  end
end
