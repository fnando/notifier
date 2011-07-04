require 'open3'
module Notifier
  module OsdCat
    extend self

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `which osd_cat > /dev/null` && $? == 0
    end

    def notify(options)
      color = options.fetch(:color, "white")
      message = options.fetch(:message, "Message")
      # command = %W[
      #   echo #{message} |
      #   osd_cat
      #   --shadow=0
      #   --colour=#{color}
      #   --pos=top
      #   --offset=10
      #   --align=center
      #   --font=-adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-*
      #   --delay=5
      #   --outline=4
      # ].join(" ")

      args = []
      args += ["--shadow", "0",
               "--color", color,
               "--pos", "top",
               "--offset", "10",
               "--align", "center",
               "--font", "-adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-*",
               "--delay", "5",
               "--outline", "4"]
      Thread.new do
          Open3.popen3('osd_cat', *args) do |stdin, stdout, stderr|
              stdin.puts(message)
              stdin.close
          end
      end
    end
  end
end
