module Notifier
  module Growl
    extend self

    @@_notifier = nil

    def supported?
      if supports_gntp?
        @@_notifier = Notifier::Growl::GNTPNotify.new
      elsif supports_growlnotify?
        @@_notifier = Notifier::Growl::GrowlNotify.new 
      else
        return false
      end
      true
    end

    def notify(options)
      return unless @@_notifier
    end

    class GNTPNotify
      def initialize
        @growl = GNTP.new( self.class.name )
        @growl.register( :notifications=>[{:name=>self.class.name, :enabled=>true}] )
      end

      def notify( options )
        @growl.notify( options.merge( {:text=>options[:message], :icon=>options[:image]} ) )
      end
    end

    class GrowlNotify
      SCRIPT = File.dirname(__FILE__) + "/../../resources/register-growl.scpt"
      FILE = File.expand_path("~/.test_notifier-growl")

      def notify(options)
        register
        command = [
          "growlnotify",
          "--name", "test_notifier",
          "--image", options[:image],
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

    private
    def supports_growlnotify?
      RUBY_PLATFORM =~ /darwin/ && `ps -Al | grep GrowlHelper` && `which growlnotify` && $? == 0 
    end

    def supports_gntp?
      begin
        require 'rubygems'
        require 'groem'
        true
      rescue LoadError
        false
      end
    end
  end
end
