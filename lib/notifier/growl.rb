module Notifier
  module Growl
    extend self

    SCRIPT = File.dirname(__FILE__) + "/../../resources/register-growl.scpt"
    FILE = File.expand_path("~/.test_notifier-growl")

    def supported?
      Notifier.os?(/darwin/) && `which growlnotify` && $? == 0
    end

    def notify(options)
      register
      command = [
        "growlnotify",
        "--name", "test_notifier",
        "--image", options.fetch(:image, ''),
        "--priority", "2",
        "--message", options[:message],
        options[:title]
      ]

      Thread.new { system(*command) }
    end

    def register
      return if File.file?(FILE)
      system "osascript #{SCRIPT} > #{FILE}"
    end
  end
end
