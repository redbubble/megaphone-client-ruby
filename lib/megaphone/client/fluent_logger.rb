require 'forwardable'
require 'fluent-logger'

module Megaphone
  class Client
    class FluentLogger
      extend Forwardable

      def_delegators :@logger, :post, :last_error

      def initialize(host, port)
        @logger = Fluent::Logger::FluentLogger.new('megaphone',
                                                   host: host,
                                                   port: port)
      end

    end
  end
end
