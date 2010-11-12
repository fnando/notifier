module Notifier
  module Growl
    extend self

    SCRIPT = File.dirname(__FILE__) + "/../../../resources/register-growl.scpt"
    FILE = File.expand_path("~/.test_notifier-growl")

    def supported?
      RUBY_PLATFORM =~ /darwin/ && `ps -Al | grep GrowlHelper` && `which growlnotify` && $? == 0
    end

    def notify(options)
      Thread.new do
        `growlnotify -n test_notifier --image #{options[:image]} -p 2 -m '#{options[:message]}' -t '#{options[:title]}'`
      end
    end

    def register
      return if File.file?(FILE)
      system "osascript #{SCRIPT} > #{FILE}"
    end
  end
end
