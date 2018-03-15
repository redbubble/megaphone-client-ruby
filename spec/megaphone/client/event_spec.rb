require 'spec_helper'

describe Megaphone::Client::Event do
  let(:topic) { 'user-events' }
  let(:subtopic) { 'user-viewed-work' }
  let(:origin) { 'redbubble' }
  let(:schema) { 'https://schema.example.com/path.json' }
  let(:partition_key) { 'abc123' }
  let(:transaction_id) { 'transaction-id' }
  let(:payload) { '{message: "hello, world"}' }
  let(:metadata) do
    {
      topic: topic,
      subtopic: subtopic,
      origin: origin,
      schema: schema,
      partition_key: partition_key,
      transaction_id: transaction_id,
    }
  end
  let(:event) { Megaphone::Client::Event.new(payload, metadata) }

  describe '#initialize' do
    context 'when a transaction_id is not provided' do
      let(:transaction_id) { nil }

      it 'generates a new transaction_id' do
        expect(event.to_hash[:transactionId]).not_to be_empty
      end
    end

    context 'when given a transaction_id' do
      let(:transaction_id) { 'my-transaction_id' }

      it 'uses the provided transaction_id' do
        expect(event.to_hash[:transactionId]).to eq('my-transaction_id')
      end
    end
  end

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

  describe '#validate!' do
    let(:subject) { event }

    context 'when a required attribute is missing' do
      let(:origin) { nil }

      it 'raises an error if the event is not valid' do
        expect { subject.validate! }.to raise_error(Megaphone::Client::MegaphoneInvalidEventError, /origin must not be empty/)
      end
    end

    context 'when event is valid' do
      it 'does not raise' do
        expect { subject.validate! }.not_to raise_error
      end
    end
  end
end
