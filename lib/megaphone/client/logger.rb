require 'megaphone/client/file_logger'
require 'megaphone/client/fluent_logger'

module Megaphone
  class Client
    class Logger
      def self.create(host = nil, port = nil)
        fluentd_host = host || ENV["MEGAPHONE_FLUENT_HOST"]
        fluentd_port = port || ENV["MEGAPHONE_FLUENT_PORT"]
        if !fluentd_port.nil? && !fluentd_port.empty? &&
           !fluentd_host.nil? && !fluentd_host.empty?
          return Megaphone::Client::FluentLogger.new(fluentd_host, fluentd_port)
        end
        Megaphone::Client::FileLogger.new
      end
    end
  end
end
