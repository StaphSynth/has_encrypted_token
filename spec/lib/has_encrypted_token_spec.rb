require 'spec_helper'

describe ActiveRecord::EncryptedToken do
  let(:user) do
    user = User.new
    user.save
    user
  end

  describe 'attribute names' do
    it 'defaults to token' do
      expect(user.token).to eq('test')
    end

    it 'respects alternative attribute names' do
      expect(user.shared_secret).to eq('test')
    end
  end
end
