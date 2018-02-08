require 'spec_helper'

describe Megaphone::Client::Event do
  let(:topic) { 'user-events' }
  let(:subtopic) { 'user-viewed-work' }
  let(:origin) { 'redbubble' }
  let(:schema) { 'https://schema.example.com/path.json' }
  let(:partition_key) { 'abc123' }
  let(:payload) { '{message: "hello, world"}' }
  let(:event) { Megaphone::Client::Event.new(topic, subtopic, origin, schema, partition_key, payload) }

  describe '#errors' do
    let(:subject) { event.errors }

    it { is_expected.to eq([]) }

    context 'when the payload is missing' do
      let(:payload) { nil }
      it { is_expected.to include('payload must not be empty') }
    end
    context 'when the topic is missing' do
      let(:topic) { nil }
      it { is_expected.to include('topic must not be empty') }
    end
    context 'when the subtopic is missing' do
      let(:subtopic) { nil }
      it { is_expected.to include('subtopic must not be empty') }
    end
    context 'when the partition key is missing' do
      let(:partition_key) { nil }
      it { is_expected.to include('partition_key must not be empty') }
    end
    context 'when the origin is missing' do
      let(:origin) { nil }
      it { is_expected.to include('origin must not be empty') }
    end
    context 'when more than one field is missing' do
      let(:origin) { nil }
      let(:payload) { nil }
      it { is_expected.to include('origin must not be empty') }
      it { is_expected.to include('payload must not be empty') }
    end
  end

  describe '#valid?' do
    let(:subject) { event.valid? }

    it { is_expected.to be true }

    context 'when the topic is missing' do
      let(:topic) { nil }
      it { is_expected.to be false }
    end

    context 'when the subtopic is missing' do
      let(:subtopic) { nil }
      it { is_expected.to be false }
    end

    context 'when the origin is missing' do
      let(:origin) { nil }
      it { is_expected.to be false }
    end

    context 'when the payload is missing' do
      let(:payload) { nil }
      it { is_expected.to be false }
    end

    context 'when the partition_key is missing' do
      let(:partition_key) { nil }
      it { is_expected.to be false }
    end

    context 'when more than one field is missing' do
      let(:origin) { nil }
      let(:payload) { nil }
      it { is_expected.to be false }
    end
  end
end
