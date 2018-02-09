require 'json'

module Megaphone
  class Client
    class Event
      def initialize(topic, subtopic, origin, schema, partition_key, payload)
        @topic = topic
        @subtopic = subtopic
        @origin = origin
        @schema = schema
        @partition_key = partition_key
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
          data: @payload
        }
      end

      def to_s
        JSON.dump(to_hash)
      end

      def errors
        errors = []
        errors << 'partition_key must not be empty' if missing?(@partition_key)
        errors << 'topic must not be empty' if missing?(@topic)
        errors << 'subtopic must not be empty' if missing?(@subtopic)
        errors << 'payload must not be empty' if missing?(@payload)
        errors << 'origin must not be empty' if missing?(@origin)
        errors
      end

      def valid?
        errors.empty?
      end

      private

      def missing?(field)
        not (field && field.to_s.length > 0)
      end
    end
  end
end
