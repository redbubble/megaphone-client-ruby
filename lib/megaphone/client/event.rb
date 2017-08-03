require 'json'

module Megaphone
  class Client
    class Event
      def initialize(topic, subtopic, origin, payload)
        @topic = topic
        @subtopic = subtopic
        @origin = origin
        @payload = payload
      end

      def to_hash
        {
          topic: @topic,
          subtopic: @subtopic,
          origin: @origin,
          payload: @payload
        }
      end

      def to_s
        JSON.dump(to_hash)
      end
    end
  end
end
