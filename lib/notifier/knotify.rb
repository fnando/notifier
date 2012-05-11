module Notifier
  module Knotify
    extend self

    def supported?
      Notifier.os?(/(linux|freebsd)/) && `ps -Al | grep dcop` && $? == 0
    end

    def notify(options)
      command = [
        "dcop", "knotify", "default", "notify", "eventname",
        options[:title], options[:message],
        "", "", "16", "2"
      ]

      Thread.new { system(*command) }
    end
  end
end
