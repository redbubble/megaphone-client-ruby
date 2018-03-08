module Megaphone
  class Client
    class MegaphoneUnavailableError < StandardError

      def initialize(msg, stream_id)
        super("#{msg} - An event could not be immediately published, but may be retried: #{stream_id}")
      end
    end

    class MegaphoneMessageDelayWarning < StandardError

      def initialize(msg, stream_id)
        super("#{msg} - Event delayed and will be reattempted: #{stream_id}")
      end
    end

    class MegaphoneInvalidEventError < StandardError

      def initialize(msg)
        super("Invalid Megaphone event was not sent: #{msg}")
      end
    end

    class MegaphoneMissingOriginError < StandardError

      def initialize
        super("Megaphone messages must have an origin. Ensure you provide an origin option, or have initialized the client with a default.")
      end
    end
  end
end
