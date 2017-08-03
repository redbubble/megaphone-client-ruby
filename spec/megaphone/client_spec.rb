require 'spec_helper'

describe Megaphone::Client do
  it 'has a version number' do
    expect(Megaphone::Client::VERSION).not_to be nil
  end

  describe '#publish!' do
    let(:config) { { origin: 'some-service' } }
    let(:client) do
      described_class.new(config, fluentd_logger)
    end

    let(:fluentd_logger) { instance_double(Megaphone::Client::FluentLogger, post: true) }

    let(:topic) { :page_changes }
    let(:subtopic) { :product_pages }
    let(:payload) { { url: 'http://rb.com/' } }

    it 'sends the event to fluentd' do
      expect(fluentd_logger).to receive(:post).with(topic, {
        topic: topic,
        subtopic: subtopic,
        origin: 'some-service',
        payload: payload
      })
      client.publish!(topic, subtopic, payload)
    end

    context 'when sending event from My Awesome Service' do

      let(:config) { { origin: 'my-awesome-service' } }

      it 'sends the event to fluentd with the origin as my aweseome service' do
        expect(fluentd_logger).to receive(:post).with(topic, hash_including(origin: 'my-awesome-service'))
        client.publish!(topic, subtopic, payload)
      end
    end

    context 'when Megaphone (fluentd) is unavailable' do

      before(:each) do
        allow(fluentd_logger).to receive(:post).and_return(false)
        allow(fluentd_logger).to receive(:last_error).and_return(Errno::ECONNREFUSED.new)
      end

      it 'raises an error' do
        expect { client.publish!(topic, subtopic, payload) }.to raise_error(Megaphone::Client::MegaphoneUnavailableError, /The following event was not published/)
      end
    end
  end
end
