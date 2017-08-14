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

      def to_hash
        {
          meta: {
            schema: @schema,
            origin: @origin,
            topic: @topic,
            subtopic: @subtopic,
            partitionKey: @partition_key
          },
          data: @payload
        }
      end

      def to_s
        JSON.dump(to_hash)
      end
    end
  end
end
