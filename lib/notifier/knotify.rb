module Notifier
  module Knotify
    extend self

    def supported?
      (RUBY_PLATFORM =~ /(linux|freebsd)/ || Config::CONFIG['host_os'] =~ /(linux|freebsd)/) &&
          `ps -Al | grep dcop` && $? == 0
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
