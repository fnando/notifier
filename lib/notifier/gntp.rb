module Notifier
  module GNTP extend self
    def supported?
      Timeout.timeout(1) { TCPSocket.new(host, port).close }
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    def port
      ENV.fetch("GNTP_PORT", 23053)
    end

    def host
      ENV["GNTP_HOST"] || ssh_connection || "127.0.0.1"
    end

    def ssh_connection
      ENV["SSH_CONNECTION"][/^([^ ]+)/, 1] if ENV["SSH_CONNECTION"]
    end

    def notify(options)
      gntp = Adapters::GNTP.new({
        :name => "test_notifier",
        :host => host,
        :port => port
      })

      gntp.notify({
        :name    => "status",
        :title   => options[:title],
        :message => options[:message],
        :icon    => options[:image]
      })
    end
  end
end
