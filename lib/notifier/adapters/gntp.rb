module Notifier
  module Adapters
    class GNTP
      attr_accessor :application_name
      attr_accessor :host
      attr_accessor :port
      attr_accessor :password

      def initialize(options = {})
        if options.kind_of?(String)
          options = {:name => options}
        end

        @application_name = options.fetch(:name, "GNTP/Ruby")
        @host = options.fetch(:host, "127.0.0.1")
        @port = options.fetch(:port, 23053)
        @password = options.fetch(:password, nil)
      end

      def line_break(number = 1)
        "\r\n" * number
      end

      def write(*contents)
        contents.map! do |content|
          content.force_encoding("utf-8") rescue content
        end

        socket = TCPSocket.open(host, port)
        message = [*contents, line_break(2)].join(line_break)
        socket.write(message)

        "".tap do |response|
          while chunk = socket.gets
            break if chunk == line_break
            response << chunk
          end

          socket.close
        end
      end

      def notify(options)
        name = options.fetch(:name, "notification")
        register(name)

        icon = fetch_icon(options[:icon])

        write "GNTP/1.0 NOTIFY NONE",
              "Application-Name: #{application_name}",
              "Notification-Name: #{name}",
              "Notification-Title: #{options[:title]}",
              "Notification-Text: #{options[:message]}",
              "Notification-Icon: x-growl-resource://#{icon[:identifier]}",
              "Notification-Sticky: #{bool options[:sticky]}",
              nil,
              "Identifier: #{icon[:identifier]}",
              "Length: #{icon[:size]}",
              nil,
              icon[:contents]
      end

      def fetch_icon(path)
        contents = File.open(path, "rb") {|f| f.read }

        {
          :identifier => Digest::MD5.hexdigest(contents),
          :contents => contents,
          :size => contents.bytesize
        }
      end

      def bool(boolean)
        {true => "Yes", false => "No"}[boolean]
      end

      def register(name)
        write "GNTP/1.0 REGISTER NONE",
              "Application-Name: #{application_name}",
              "Notifications-count: 1",
              nil,
              "Notification-Name: #{name}",
              "Notification-Enabled: True"
      end
    end
  end
end
