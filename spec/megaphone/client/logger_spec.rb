require 'spec_helper'

describe Megaphone::Client::Logger do

  describe '#create' do
    let(:client) { Megaphone::Client::Logger.create() }

    it 'creates a file logger with default configuration' do
      expect(client).to be_an_instance_of(Megaphone::Client::FileLogger)
    end

    context 'when custom parameters are provided' do

      context "when a custom 'host' parameter is provided" do
        it 'creates a file logger with default configuration' do
          lient = Megaphone::Client::Logger.create('custom host', nil)
          expect(client).to be_an_instance_of(Megaphone::Client::FileLogger)
        end
      end

      context "when a custom 'port' parameter is provided" do
        it 'creates a file logger with default configuration' do
          client = Megaphone::Client::Logger.create(nil, 'custom port')
          expect(client).to be_an_instance_of(Megaphone::Client::FileLogger)
        end
      end

      context "when both a custom 'host' and 'port' parameters are provided" do
        it 'creates a fluent logger using them with a default overflow handler' do
          # Should create default overflow handler
          expect(Megaphone::Client::FluentLogger).to receive(:new).with('custom host', '424242', nil).and_call_original

          client = Megaphone::Client::Logger.create('custom host', '424242')
          expect(client).to be_an_instance_of(Megaphone::Client::FluentLogger)
        end
      end

      context "when host, port and overflow parameters are provided" do
        it 'creates a fluent logger using them' do
          overflow_handler = -> (*) { }
          expect(Megaphone::Client::FluentLogger).to receive(:new).with('somehost', '2424', overflow_handler).and_call_original

          client = Megaphone::Client::Logger.create('somehost', '2424', overflow_handler)
          expect(client).to be_an_instance_of(Megaphone::Client::FluentLogger)
        end
      end

    end
  end
end
