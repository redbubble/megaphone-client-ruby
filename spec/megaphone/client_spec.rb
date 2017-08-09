require 'spec_helper'

describe Megaphone::Client do
  it 'has a version number' do
    expect(Megaphone::Client::VERSION).not_to be nil
  end

  describe '#publish!' do
    let(:config) { { origin: 'some-service' } }
    let(:client) do
      described_class.new(config, logger)
    end

    let(:topic) { :page_changes }
    let(:subtopic) { :product_pages }
    let(:payload) { { url: 'http://rb.com/' } }

    context 'when fluentd logger is used' do
      let(:logger) { instance_double(Megaphone::Client::FluentLogger, post: true) }

      it 'sends the event to fluentd' do
        expect(logger).to receive(:post).with(topic, {
          topic: topic,
          subtopic: subtopic,
          origin: 'some-service',
          payload: payload
        })
        client.publish!(topic, subtopic, payload)
      end

      context 'when sending event from My Awesome Service' do

        let(:config) { { origin: 'my-awesome-service' } }

        it 'sends the event to fluentd with the origin as my awesome service' do
          expect(logger).to receive(:post).with(topic, hash_including(origin: 'my-awesome-service'))
          client.publish!(topic, subtopic, payload)
        end
      end

      context 'when Megaphone (fluentd) is unavailable' do

        before(:each) do
          allow(logger).to receive(:post).and_return(false)
          allow(logger).to receive(:last_error).and_return(Errno::ECONNREFUSED.new)
        end

        it 'raises an error' do
          expect { client.publish!(topic, subtopic, payload) }.to raise_error(Megaphone::Client::MegaphoneUnavailableError, /The following event was not published/)
        end
      end
    end

    context 'when file logger is used' do
      let(:logger) { Megaphone::Client::FileLogger.new }
      let(:expected_filename) { "page_changes.stream" }
      let(:expected_file_permission) { "a" }
      let(:expected_file_content) do
        "{\"topic\":\"page_changes\",\"subtopic\":\"product_pages\",\"origin\":\"some-service\",\"payload\":{\"url\":\"http://rb.com/\"}}"
      end

      it 'sends the event to a file' do
        file = double('file')
        expect(File).to receive(:open).with(expected_filename, expected_file_permission).and_yield(file)
        expect(file).to receive(:puts).with(expected_file_content)

        client.publish!(topic, subtopic, payload)
      end
    end
  end
end
