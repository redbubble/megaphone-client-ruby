require 'forwardable'
require 'fluent-logger'

module Megaphone
  class Client
    class FluentLogger
      extend Forwardable

      def_delegators :@logger, :post, :last_error, :close

      def initialize(host, port, overflow_handler = nil)
        overflow_handler ||= default_overflow_handler
        @logger = Fluent::Logger::FluentLogger.new('megaphone',
                                                   host: host,
                                                   port: port,
                                                   buffer_overflow_handler: overflow_handler
                                                 )
      end

      private
      # A default overflow handler that just prints a warning message.
      # Production applications should be passing in their own handlers,
      # which should be alerting monitoring systems!
      def default_overflow_handler
        $stderr.puts("Megaphone::Client::FluentLogger - Production apps MUST override buffer overflow handler!")
        -> (*) {
          $stderr.puts("Buffer overflow in Megaphone/fluent logger - messages lost")
        }
      end

    end
  end
end
