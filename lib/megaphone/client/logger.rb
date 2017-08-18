require 'megaphone/client/file_logger'
require 'megaphone/client/fluent_logger'

module Megaphone
  class Client
    class Logger
      def self.create(host = nil, port = nil)
        if !port.nil? && !port.empty? &&
           !host.nil? && !host.empty?
          return FluentLogger.new(host, port)
        end
        FileLogger.new
      end
    end
  end
end
