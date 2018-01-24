require 'megaphone/client/logger'
require 'megaphone/client/errors'
require 'megaphone/client/event'
require 'megaphone/client/version'

module Megaphone
  class Client
    attr_reader :logger, :origin
    private :logger, :origin

    # Main entry point for apps using this library.
    # Will default to environment for host and port settings, if not passed.
    # Note that a missing callback_handler will result in a default handler
    # being assigned if the FluentLogger is used.
    def initialize(config)
      @origin = config.fetch(:origin)
      host = config.fetch(:host, ENV['MEGAPHONE_FLUENT_HOST'])
      port = config.fetch(:port, ENV['MEGAPHONE_FLUENT_PORT'])
      overflow_handler = config.fetch(:overflow_handler, nil)
      @logger = Megaphone::Client::Logger.create(host, port, overflow_handler)
    end

    def publish!(topic, subtopic, schema, partition_key, payload)
      event = Event.new(topic, subtopic, origin, schema, partition_key, payload)
      unless logger.post(topic, event.to_hash)
        if logger.last_error.message.include?("Connection reset by peer")
          raise MegaphoneMessageDelayWarning.new(logger.last_error.message, event)
        else
          raise MegaphoneUnavailableError.new(logger.last_error.message, event)
        end
      end
    end

    def close
      logger.close
    end
  end
end
