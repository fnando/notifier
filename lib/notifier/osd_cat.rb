module Notifier
  module OsdCat
    extend self

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `which osd_cat > /dev/null` && $? == 0
    end

    def notify(options)
      color = options.fetch(:color, "white")
      message = options[:message].inspect.gsub(/!/, "\\!")
      command = %W[
        echo #{message} |
        osd_cat
        --shadow=0
        --colour=#{color}
        --pos=top
        --offset=10
        --align=center
        --font=-adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-*
        --delay=5
        --outline=4
      ].join(" ")

      Thread.new { `#{command}` }
    end
  end
end
