# frozen_string_literal: true

module Notifier
  module Hud
    extend self

    def supported?
      Notifier.os?(/darwin/) && hud_bin
    end

    def hud_bin
      @hud_bin ||= [
        "/Applications/hud.app/Contents/MacOS/cli",
        File.expand_path("~/Applications/hud.app/Contents/MacOS/cli")
      ].find {|path| File.file?(path) }
    end

    def notify(options)
      options[:image] ||= "apple.terminal"

      command = [
        hud_bin,
        "--title", options[:title].to_s,
        "--message", options[:message].to_s,
        "--symbol-name", options[:image].to_s
      ]

      Thread.new { system(*command) }.join
    end
  end
end
