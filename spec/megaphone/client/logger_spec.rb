require 'spec_helper'

describe Megaphone::Client::Logger do
  describe '#create' do
    subject { Megaphone::Client::Logger.create }

    after do
      ENV.delete('MEGAPHONE_FLUENT_HOST')
      ENV.delete('MEGAPHONE_FLUENT_PORT')
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
