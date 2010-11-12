module Notifier
  module OsdCat
    extend self

    FONT = "-bitstream-charter-bold-r-normal--33-240-100-100-p-206-iso8859-1"
    POSITION = "top"
    POSITION_OFFSET = "0"
    ALIGN = "center"
    COLORS = {
      :fail => "orange",
      :success => "green",
      :error => "red"
    }

    def supported?
      RUBY_PLATFORM =~ /(linux|freebsd)/ && `which osd_cat > /dev/null` && $? == 0
    end

    def notify(options)
      Thread.new do
        `echo #{options[:message].inspect} | osd_cat --font=#{FONT} --shadow=0 --pos=#{POSITION} -o #{POSITION_OFFSET} --delay=4 --outline=4 --align=#{ALIGN} -c #{COLORS[options[:status]]}`
      end
    end
  end
end
