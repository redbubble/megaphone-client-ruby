require 'megaphone/client/file_logger'
require 'megaphone/client/fluent_logger'

module Megaphone
  class Client
    class Logger

      def self.create(host = nil, port = nil, overflow_handler = nil)
        if !port.nil? && !port.empty? &&
           !host.nil? && !host.empty?
          return FluentLogger.new(host, port, overflow_handler)
        end
        FileLogger.new
      end
    end
  end
end
