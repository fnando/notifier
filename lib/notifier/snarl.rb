module Notifier
  module Snarl
    extend self

    def supported?
      return false unless RUBY_PLATFORM =~ /(mswin|mingw)/

      begin
        require "snarl" unless defined?(::Snarl)
        true
      rescue LoadError
        false
      end
    end

    def notify(options)
      ::Snarl.show_message(options[:title], options[:message], options[:image])
    end
  end
end
