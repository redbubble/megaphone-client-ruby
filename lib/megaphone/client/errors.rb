module Megaphone
  class Client
    class MegaphoneUnavailableError < StandardError

      def initialize(msg, event)
        super(msg)
        @msg = msg
        @event = event
      end

      def to_s
        "#{@msg} - An event could not be immediately published, but may be retried: #{@event.stream_id}"
      end
    end

    class MegaphoneMessageDelayWarning < StandardError

      def initialize(msg, event)
        super(msg)
        @msg = msg
        @event = event
      end

      def to_s
        "#{@msg} - Event delayed and will be reattempted: #{@event.stream_id}"
      end
    end
  end
end
