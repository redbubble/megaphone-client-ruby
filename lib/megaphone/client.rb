require 'megaphone/client/fluent_logger'
require 'megaphone/client/errors'
require 'megaphone/client/event'
require 'megaphone/client/version'

module Megaphone
  class Client
    attr_reader :logger, :origin
    private :logger, :origin

    def initialize(config, logger = Megaphone::Client::FluentLogger.new)
      @logger = logger
      @origin = config.fetch(:origin)
    end

    def publish!(topic, subtopic, payload)
      event = Event.new(topic, subtopic, origin, payload)
      unless logger.post(topic, event.to_hash)
        raise MegaphoneUnavailableError.new(logger.last_error.message, event)
      end
    end
  end
end
