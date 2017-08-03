require 'forwardable'
require 'fluent-logger'

module Megaphone
  class Client
    class FluentLogger
      extend Forwardable

      def_delegators :@logger, :post, :last_error

      def initialize
        host = 'localhost'
        port = 24224
        @logger = Fluent::Logger::FluentLogger.new('megaphone',
                                                   host: host,
                                                   port: port)
      end

    end
  end
end
