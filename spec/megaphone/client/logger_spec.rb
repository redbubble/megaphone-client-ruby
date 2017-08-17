require 'spec_helper'

describe Megaphone::Client::Logger do
  describe '#create' do
    let(:host) { nil }
    let(:port) { nil }

    subject { Megaphone::Client::Logger.create(host, port) }

    after do
      ENV.delete('MEGAPHONE_FLUENT_HOST')
      ENV.delete('MEGAPHONE_FLUENT_PORT')
    end

    context 'when host and port are present' do

      let(:host) { 'localhost' }
      let(:port) { '24224' }

      it 'creates a fluent logger using them' do
        expect(subject).to be_an_instance_of(Megaphone::Client::FluentLogger)

      end

      context 'when megaphone fluent env variables are present' do
        it 'creates a fluent logger using host and port (not environment variables)' do
          ENV['MEGAPHONE_FLUENT_HOST'] = 'another-host'
          ENV['MEGAPHONE_FLUENT_PORT'] = 'another-port'
          expect(Megaphone::Client::FluentLogger).to receive(:new).with(host, port)
          subject
        end
      end
    end
    context 'when megaphone fluent env variables are present' do
      it 'creates a fluent logger' do
        ENV['MEGAPHONE_FLUENT_HOST'] = 'localhost'
        ENV['MEGAPHONE_FLUENT_PORT'] = '24224'
        expect(subject).to be_an_instance_of(Megaphone::Client::FluentLogger)
      end
    end

    context 'when megaphone fluent host env variable is not present' do
      it 'creates a file logger' do
        ENV['MEGAPHONE_FLUENT_PORT'] = '24224'
        expect(subject).to be_an_instance_of(Megaphone::Client::FileLogger)
      end
    end

    context 'when megaphone fluent port env variable is not present' do
      it 'creates a file logger' do
        ENV['MEGAPHONE_FLUENT_HOST'] = 'localhost'
        expect(subject).to be_an_instance_of(Megaphone::Client::FileLogger)
      end
    end

    context 'when megaphone fluent env variables are not present' do
      it 'creates a file logger' do
        expect(subject).to be_an_instance_of(Megaphone::Client::FileLogger)
      end
    end
  end
end
