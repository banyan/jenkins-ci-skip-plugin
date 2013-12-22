require 'spec_helper'

describe CiSkip::Matcher do
  describe '#skip?' do
    it 'should not skip' do
      messages = [
        "initial commit",
        "foo [ci unknown-command] bar"
      ]
      messages.each do |message|
        expect(described_class.new(message).skip?).to eq false
      end
    end

    it 'should skip' do
      messages = [
        "foo [ci skip] bar",
        "foo [CI skip] bar",
        "foo [skip ci] bar",
        "foo bar \n\n[ci skip]"
      ]
      messages.each do |message|
        expect(described_class.new(message).skip?).to eq true
      end
    end
  end
end
