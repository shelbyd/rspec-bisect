require 'spec_helper'

require 'json'
require 'rspec/bisect/result'

describe RSpec::Bisect::Result do
  describe '#as_json' do
    subject { described_class.new(result).as_json }

    context 'with one line of json' do
      let(:result) { { some: 'json' }.to_json }

      it { is_expected.to eq({'some' => 'json'}) }
    end

    context 'with deprecation warnings' do
      let(:result) do
        "Don't use should, use expect instead
        {\"some\": \"json\"}"
      end

      it { is_expected.to eq({'some' => 'json'}) }
    end

    context 'with bad output after json' do
      let(:result) do
        "{\"some\": \"json\"}
        Something else to mess up our code..."
      end

      it { is_expected.to eq({'some' => 'json'}) }
    end

    context 'with no json' do
      let(:result) do
        "There's no json here
        Go away"
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(RSpec::Bisect::Result::ParserError, 'Could not parse json')
      end
    end
  end
end
