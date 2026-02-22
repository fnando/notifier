# frozen_string_literal: true

module Notifier
  module Noop
    extend self

    def supported?
      true
    end

    def notify(options)
    end
  end
end
