module Megaphone
  class Client
    class MegaphoneUnavailableError < StandardError

      def initialize(msg, event)
        super(msg)
        @msg = msg
        @event = event
      end

      def to_s
        "#{@msg} - The following event was not published: #{@event.to_s}"
      end
    end
  end
end
