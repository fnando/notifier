# frozen_string_literal: true

module Notifier
  module OsdCat
    extend self

    def supported?
      Notifier.os?(/(linux|freebsd)/) &&
        `which osd_cat > /dev/null` &&
        $CHILD_STATUS == 0
    end

    def notify(options)
      color = options.fetch(:color, "white").to_s

      command = [
        "osd_cat",
        "--shadow", "0",
        "--colour", color,
        "--pos", "top",
        "--offset", "10",
        "--align", "center",
        "--font", "-bitstream-bitstream charter-bold-r-*-*-*-350-*-*-*-*-*-*",
        "--delay", "5",
        "--outline", "4"
      ]

      Thread.new do
        Open3.popen3(*command) do |stdin, _stdout, _stderr|
          stdin.puts options[:message]
          stdin.close
        end
      end.join
    end
  end
end
