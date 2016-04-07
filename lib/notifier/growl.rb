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
        "--image", options.fetch(:image, "").to_s,
        "--priority", "2",
        "--message", options[:message].to_s,
        options[:title].to_s
      ]

      Thread.new { system(*command) }.join
    end

    def register
      return if File.file?(FILE)
      system "osascript #{SCRIPT} > #{FILE}"
    end
  end
end
