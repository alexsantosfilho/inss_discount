require 'rails_helper'

RSpec.describe Current, type: :model do
  describe 'attributes' do
    it { is_expected.to respond_to(:session) }
    it { is_expected.to respond_to(:session=) }
    it { is_expected.to respond_to(:user) }
  end

  describe '#user' do
    context 'when session is present' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { Current.session = session }

      it 'returns the user associated with the session' do
        expect(Current.user).to eq(user)
      end
    end

    context 'when session is nil' do
      before { Current.session = nil }

      it 'returns nil' do
        expect(Current.user).to be_nil
      end
    end
  end
end
