require 'spec_helper'

describe CiSkipWrapper do
  let(:build)    { double(native: double(getChangeSet: changeset)) }
  let(:launcher) { double }
  let(:listener) { double }
  let(:wrapper)  { CiSkipWrapper.new({'ci_skip' => true}) }

  describe '#setup' do
    context 'when changeset is empty' do
      let(:changeset) { double(isEmptySet: true) }

      it 'should get back to normal build' do
        expect(listener).to receive(:info).with('Empty changeset, running build.')
        wrapper.setup(build, launcher, listener)
      end
    end

    context 'when changeset is not empty' do
      context 'when message includes [ci skip]' do
        let(:changeset) {
          double(isEmptySet: false, getLogs:
            double(size: 1, get:
              double(getComment: 'foobar [ci skip]', getCommitId: 'b2bb7ab')
            )
          )
        }

        it 'should skip build' do
          allow(wrapper).to receive(:halt) { build }
          expect(listener).to receive(:info).with('Message: foobar [ci skip]')
          expect(listener).to receive(:info).with('Commit: b2bb7ab')
          expect(listener).to receive(:info).with('Build is skipped through commit message.')
          wrapper.setup(build, launcher, listener)
        end
      end

      context 'when message does not include [ci skip]' do
        let(:changeset) {
          double(isEmptySet: false, getLogs:
            double(size: 1, get:
              double(getComment: 'foobar', getCommitId: 'b2bb7ab')
            )
          )
        }

        it 'should get back to normal build' do
          expect(listener).to_not receive(:info)
          wrapper.setup(build, launcher, listener)
        end
      end

      context 'when raise an error' do
        let(:changeset) {
          double(isEmptySet: false, getLogs:
            double(size: 1, get:
              double(getComment: 'foobar', getCommitId: 'b2bb7ab')
            )
          )
        }

        it 'should get back to normal build' do
          allow_any_instance_of(CiSkip::Matcher).to receive(:skip?).and_raise
          expect(listener).to receive(:error).twice
          wrapper.setup(build, launcher, listener)
        end
      end
    end
  end
end
