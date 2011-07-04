module Notifier
  module Growl
    extend self

    SCRIPT = File.dirname(__FILE__) + "/../../resources/register-growl.scpt"
    FILE = File.expand_path("~/.test_notifier-growl")

    def supported?
      RUBY_PLATFORM =~ /darwin/ && `ps -Al | grep GrowlHelper` && `which growlnotify` && $? == 0
    end

    def notify(options)
      register
      Thread.new { 
          args = []
          args += ["--name", "test_notifier"]
          args += ["--image", options[:image]] if options[:image]
          args += ["--priority", "2"]
          args += ["--message", options[:message]] if options[:message]
          args += [options[:title]] if options[:title]
          system("growlnotify", *args)
      }
    end

    def register
      return if File.file?(FILE)
      system "osascript #{SCRIPT} > #{FILE}"
    end
  end
end
