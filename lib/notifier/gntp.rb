module Notifier
  module GNTP
    extend self

    def supported?
      begin
        require "ruby_gntp" unless defined?(::GNTP)
        true
      rescue LoadError
        false
      end
    end

    def notify(options)
      ::GNTP.notify(
          :title => options[:title],
          :text => options[:message],
          :icon => options[:image]
      )
    end
  end
end
