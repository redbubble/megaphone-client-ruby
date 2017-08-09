require 'json'

module Megaphone
  class Client
    class FileLogger
      def post(topic, event)
        File.open("#{topic}.stream", 'a') do |f|
          f.puts event.to_json
        end
        true
      end

      def last_error
      end
    end
  end
end
