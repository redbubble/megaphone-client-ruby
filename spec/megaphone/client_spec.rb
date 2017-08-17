require 'spec_helper'

describe Megaphone::Client do
  it 'has a version number' do
    expect(Megaphone::Client::VERSION).not_to be nil
  end

  describe '#publish!' do
    let(:config) { { origin: 'some-service' } }
    let(:client) do
      described_class.new(config)
    end

    let(:topic) { :page_changes }
    let(:subtopic) { :product_pages }
    let(:schema) { 'http://www.github.com/redbuble/megaphone-event-type-registry/topics/cats' }
    let(:payload) { { url: 'http://rb.com/' } }
    let(:partition_key) { 42 }

    before do
      allow(Megaphone::Client::Logger).to receive(:create).and_return(logger)
    end

    context 'when fluentd logger is used' do
      let(:logger) { instance_double(Megaphone::Client::FluentLogger, post: true) }

      it 'sends the event to fluentd' do
        expect(logger).to receive(:post).with(topic, {
          meta: {
            schema: schema,
            topic: topic,
            subtopic: subtopic,
            origin: 'some-service',
            partitionKey: partition_key
          },
          data: payload
        })
        client.publish!(topic, subtopic, schema, partition_key, payload)
      end

      context 'when sending event from My Awesome Service' do

        let(:config) { { origin: 'my-awesome-service' } }

        it 'sends the event to fluentd with the origin as my awesome service' do
          expect(logger).to receive(:post).with(topic, hash_including(meta: hash_including(origin: 'my-awesome-service')))
          client.publish!(topic, subtopic, schema, partition_key, payload)
        end
      end

      context 'when Megaphone (fluentd) is unavailable' do

        before(:each) do
          allow(logger).to receive(:post).and_return(false)
          allow(logger).to receive(:last_error).and_return(Errno::ECONNREFUSED.new)
        end

        it 'raises an error' do
          expect { client.publish!(topic, subtopic, schema, partition_key, payload) }.to raise_error(Megaphone::Client::MegaphoneUnavailableError, /The following event was not published/)
        end
      end
    end

    context 'when file logger is used' do
      let(:logger) { Megaphone::Client::FileLogger.new }
      let(:expected_filename) { "page_changes.stream" }
      let(:expected_file_permission) { "a" }
      let(:expected_file_content) do
        "{\"meta\":{\"schema\":\"http://www.github.com/redbuble/megaphone-event-type-registry/topics/cats\",\"origin\":\"some-service\",\"topic\":\"page_changes\",\"subtopic\":\"product_pages\",\"partitionKey\":42},\"data\":{\"url\":\"http://rb.com/\"}}"
      end

      it 'sends the event to a file' do
        file = double('file')
        expect(File).to receive(:open).with(expected_filename, expected_file_permission).and_yield(file)
        expect(file).to receive(:puts).with(expected_file_content)

        client.publish!(topic, subtopic, schema, partition_key, payload)
      end
    end
  end
end
