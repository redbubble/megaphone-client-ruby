require 'spec_helper'

describe Megaphone::Client do
  it 'has a version number' do
    expect(Megaphone::Client::VERSION).not_to be nil
  end

  describe '#initialize' do

    let(:config) {{ origin: 'my-awesome-service' }}

    it 'creates a logger', focus: true do
      expect(Megaphone::Client::Logger).to receive(:create).with(nil, Megaphone::Client::FLUENT_DEFAULT_PORT, nil)
      described_class.new(config)
    end

    context 'when MEGAPHONE_FLUENT_HOST or MEGAPHONE_FLUENT_PORT environment variables are set' do

      before(:each) do
        ENV['MEGAPHONE_FLUENT_HOST'] = 'env host'
        ENV['MEGAPHONE_FLUENT_PORT'] = 'env port'
      end

      after do
        ENV.delete('MEGAPHONE_FLUENT_HOST')
        ENV.delete('MEGAPHONE_FLUENT_PORT')
      end

      it 'creates a logger using the value of the env. variables', focus: true do
        expect(Megaphone::Client::Logger).to receive(:create).with('env host', 'env port', nil)
        described_class.new(config)
      end
    end

    context "when custom values for 'host' and 'port' are provided as configuration" do

      it 'the configured values take precedence over the env. variable values' do
        expect(Megaphone::Client::Logger).to receive(:create).with('config host', 'config port', nil)
        described_class.new(config.merge({
          host: 'config host',
          port: 'config port'
        }))
      end
    end
  end

  describe '#publish!' do

    let(:config) { { origin: 'some-service' } }
    let(:client) do
      described_class.new(config)
    end

    let(:topic) { 'work-updates' }
    let(:subtopic) { 'work-metadata-updated' }
    let(:schema) { 'http://github.com/redbuble/megaphone-event-type-registry/streams/work-updates-1.0.0.json' }
    let(:payload) { { url: 'http://example.rb.com/works/123456' } }
    let(:partition_key) { 42 }
    let(:transaction_id) { 'transaction-id' }
    let(:metadata) do
      {
        topic: topic,
        subtopic: subtopic,
        schema: schema,
        partition_key: partition_key,
        transaction_id: transaction_id,
      }
    end

    before do
      allow(Megaphone::Client::Logger).to receive(:create).and_return(logger)
    end

    context 'when fluentd logger is used' do
      let(:logger) { instance_double(Megaphone::Client::FluentLogger, post: true) }

      it 'sends the event to fluentd' do
        expect(logger).to receive(:post).with(topic, {
          schema: schema,
          topic: topic,
          subtopic: subtopic,
          origin: 'some-service',
          partitionKey: partition_key,
          transactionId: transaction_id,
          data: payload
        })
        client.publish!(payload, metadata)
      end

      context 'when sending event from My Awesome Service' do

        let(:config) { { origin: 'my-awesome-service' } }

        it 'sends the event to fluentd with the origin as my awesome service' do
          expect(logger).to receive(:post).with(topic, hash_including(origin: 'my-awesome-service'))
          client.publish!(payload, metadata)
        end
      end

      context 'when Megaphone (fluentd) is unavailable' do

        before(:each) do
          allow(logger).to receive(:post).and_return(false)
          allow(logger).to receive(:last_error).and_return(Errno::ECONNREFUSED.new)
        end

        it 'raises an error' do
          expect { client.publish!(payload, metadata) }.to raise_error(Megaphone::Client::MegaphoneUnavailableError, /An event could not be immediately published/)
        end
      end
    end

    context 'when file logger is used' do
      let(:logger) { Megaphone::Client::FileLogger.new }
      let(:expected_filename) { "work-updates.stream" }
      let(:expected_file_permission) { "a" }
      let(:expected_file_content) do
        "{\"schema\":\"#{schema}\",\"origin\":\"some-service\",\"topic\":\"work-updates\",\"subtopic\":\"work-metadata-updated\",\"partitionKey\":42,\"transactionId\":\"transaction-id\",\"data\":{\"url\":\"http://example.rb.com/works/123456\"}}"
      end

      it 'sends the event to a file' do
        file = double('file')
        expect(File).to receive(:open).with(expected_filename, expected_file_permission).and_yield(file)
        expect(file).to receive(:puts).with(expected_file_content)

        client.publish!(payload, metadata)
      end
    end
  end

  describe '#overflow_handler' do
    let(:topic) { 'work-updates' }
    let(:subtopic) { 'work-metadata-updated' }
    let(:schema) { 'http://github.com/redbuble/megaphone-event-type-registry/streams/work-updates-1.0.0.json' }
    let(:payload) { { url: 'http://example.rb.com/works/123456' } }
    let(:partition_key) { 42 }
    let(:transaction_id) { 'transaction-id' }
    let(:metadata) do
      {
        topic: topic,
        subtopic: subtopic,
        schema: schema,
        partition_key: partition_key,
        transaction_id: transaction_id,
      }
    end

    context 'when overflow_handler was configured' do
      handler_called = 0
      handler = -> (*) {
        handler_called = 1
      }

      my_config = {
        origin: "some-service",
        overflow_handler: handler,
        host: "localhost",
        port: "60666",
      }

      it 'calls the overflow handler on close if messages did not send' do
        client = described_class.new(my_config)
        begin
          client.publish!(payload, metadata)
        rescue Megaphone::Client::MegaphoneUnavailableError => e
          puts("ignoring MegaphoneUnavailableError")
        end
        client.close
        expect(handler_called).to eql(1)
      end
    end
  end

end
