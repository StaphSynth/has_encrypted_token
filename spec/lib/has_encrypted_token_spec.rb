require 'spec_helper'

describe ActiveRecord::EncryptedToken do
  let(:user) do
    user = User.create
    user
  end

  describe 'attribute names' do
    it 'defaults to token' do
      expect(user.respond_to?(:token)).to be(true)
    end

    it 'respects alternative attribute names' do
      expect(user.respond_to?(:shared_secret)).to be(true)
    end
  end

  context 'generating and validating tokens' do
    let(:unencrypted_token) { 'unencrypted_token' }
    let(:encrypted_token) { '$encrypted_token$' }

    before do
      allow(User).to receive(:generate_token).and_return(unencrypted_token)
      allow(BCrypt::Password).to receive(:create).and_return(encrypted_token)
      allow(BCrypt::Password).to(
        receive(:new).with(encrypted_token).and_return(unencrypted_token)
      )
    end

    describe '#regenerate_{attribute}' do
      it 'returns a new token' do
        expect(user.regenerate_token).to eq(unencrypted_token)
      end

      it 'encrypts the new token and stores it in the database' do
        user.regenerate_token

        expect(user.reload.token).to eq(encrypted_token)
      end
    end

    describe '#authenticate_{attribute}' do
      context 'when passed an unencrypted token' do
        before do
          user.regenerate_token
        end

        it 'returns true if it matches the stored value' do
          expect(user.authenticate_token(unencrypted_token)).to eq(true)
        end

        it 'returns false if it does not match the stored value' do
          expect(user.authenticate_token('derp derp')).to eq(false)
        end
      end
    end
  end
end
