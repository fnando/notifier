module Notifier
  module Snarl
    extend self

    def supported?
      return false unless RUBY_PLATFORM =~ /(mswin|mingw)/

      begin
        require 'rubygems' # windows 1.8.7 ruby by default doesn't load rubygems
        require "snarl" unless defined?(::Snarl)
        true
      rescue LoadError
        false
      end
    end

    def notify(options)
      ::Snarl.show_message(options.fetch(:title,"Notification"), 
                           options.fetch(:message, "Message") , 
                           options[:image])
    end
  end
end
