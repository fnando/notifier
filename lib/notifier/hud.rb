# frozen_string_literal: true

module Notifier
  module Hud
    extend self

    def supported?
      Notifier.os?(/darwin/) && hud?
    end

    def uri
      URI("http://127.0.0.1:32323/hud")
    end

    def hud?
      return @hud unless @hud.nil?

      @hud = begin
        response = Net::HTTP.get_response(uri)
        response.code == "200"
      rescue StandardError
        false
      end

      @hud
    end

    def notify(options)
      Thread.new do
        Net::HTTP.post_form(
          uri,
          {
            "title" => options[:title].to_s,
            "message" => options[:message].to_s,
            "symbolName" => options[:image].to_s
          }
        )
      end.join
    end
  end
end
