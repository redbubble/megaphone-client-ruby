require 'megaphone/client/logger'
require 'megaphone/client/errors'
require 'megaphone/client/event'
require 'megaphone/client/version'

module Megaphone
  class Client
    FLUENT_DEFAULT_PORT = '24224'

    # Main entry point for apps using this library.
    # Will default to environment for host and port settings, if not passed.
    # Note that a missing callback_handler will result in a default handler
    # being assigned if the FluentLogger is used.
    def initialize(config)
      @origin = config.fetch(:origin)
      host = config.fetch(:host, ENV['MEGAPHONE_FLUENT_HOST'])
      port = config.fetch(:port, ENV['MEGAPHONE_FLUENT_PORT'] || FLUENT_DEFAULT_PORT)
      overflow_handler = config.fetch(:overflow_handler, nil)
      @logger = Megaphone::Client::Logger.create(host, port, overflow_handler)
    end

    def publish!(payload, metadata = {})
      metadata = default_metadata.merge(metadata)
      event = Event.new(payload, metadata)
      event.validate!
      unless logger.post(metadata[:topic], event.to_hash)
        if transient_error?(logger.last_error)
          raise MegaphoneMessageDelayWarning.new(logger.last_error.message, event.stream_id)
        else
          raise MegaphoneUnavailableError.new(logger.last_error.message, event.stream_id)
        end
      end
    end

    def close
      logger.close
    end

    private

    attr_reader :logger, :origin

    def default_metadata
      {
        origin: origin,
      }
    end

    def transient_error?(err)
      err_msg = err.message
      if err_msg.include?("Connection reset by peer")
        true
      elsif err_msg.include?("Broken pipe")
        true
      else
        false
      end
    end

  end
end
