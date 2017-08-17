require 'megaphone/client/logger'
require 'megaphone/client/errors'
require 'megaphone/client/event'
require 'megaphone/client/version'

module Megaphone
  class Client
    attr_reader :logger, :origin
    private :logger, :origin

    def initialize(config)
      @origin = config.fetch(:origin)
      @logger = Megaphone::Client::Logger.create(config[:host],
                                                 config[:port])
    end

    def publish!(topic, subtopic, schema, partition_key, payload)
      event = Event.new(topic, subtopic, origin, schema, partition_key, payload)
      unless logger.post(topic, event.to_hash)
        raise MegaphoneUnavailableError.new(logger.last_error.message, event)
      end
    end
  end
end
