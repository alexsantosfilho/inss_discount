require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to have_secure_password }
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
  end

  describe 'normalizations' do
    it 'normalizes email address by stripping and downcasing' do
      user = User.new(email_address: '  EXAMPLE@example.com ')
      user.valid?
      expect(user.email_address).to eq('example@example.com')
    end
  end
end
