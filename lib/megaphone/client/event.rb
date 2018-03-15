require 'json'

module Megaphone
  class Client
    class Event
      REQUIRED_ATTRIBUTES = [:partition_key, :topic, :subtopic, :payload, :origin, :transaction_id]

      def initialize(payload, metadata = {})
        @topic = metadata[:topic]
        @subtopic = metadata[:subtopic]
        @origin = metadata[:origin]
        @schema = metadata[:schema]
        @partition_key = metadata[:partition_key]
        @transaction_id = metadata[:transaction_id]
        @payload = payload
      end

      def stream_id
        "#{@topic}.#{@subtopic}"
      end

      def to_hash
        {
          schema: @schema,
          origin: @origin,
          topic: @topic,
          subtopic: @subtopic,
          partitionKey: @partition_key,
          transactionId: @transaction_id,
          data: @payload,
        }
      end

      def to_s
        JSON.dump(to_hash)
      end

      def errors
        REQUIRED_ATTRIBUTES.reduce([]) do |errors, attr|
          if missing?(instance_variable_get("@#{attr}"))
            errors << "#{attr} must not be empty"
          end

          errors
        end
      end

      def valid?
        errors.empty?
      end

      def validate!
        raise MegaphoneInvalidEventError.new(errors.join(', ')) unless valid?
      end

      private

      def missing?(field)
        not (field && field.to_s.length > 0)
      end
    end
  end
end
