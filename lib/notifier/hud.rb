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
        "~/Applications/hud.app/Contents/MacOS/cli"
      ].first {|path| File.expand_path(path) }
    end

    def notify(options)
      command = [
        hud_bin,
        "--title",
        options[:title].to_s,
        "--message",
        options[:message].to_s,
        "--symbol-name",
        options[:image].to_s
      ]

      Thread.new { system(*command) }.join
    end
  end
end
