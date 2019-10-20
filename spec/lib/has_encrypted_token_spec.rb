require 'spec_helper'

describe ActiveRecord::EncryptedToken do
  let(:user) { User.create }

  describe 'attribute name for token storage and related methods' do
    context 'when no argument is passed' do
      it 'defaults to "token"' do
        expect(user.respond_to?(:regenerate_token)).to be(true)
      end
    end

    context 'when a symbol is passed' do
      let(:user) { SpecialUser.create }

      it 'uses it as an attribute name' do
        expect(user.respond_to?(:regenerate_shared_secret)).to be(true)
        expect(user.respond_to?(:regenerate_token)).to be(false)
      end
    end
  end

  context 'instance methods' do
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

    describe '#{attribute}=' do
      context 'when passed a value' do
        it 'encrypts it and stores the encrypted value in the model instance' do
          user.token = unencrypted_token

          expect(user.token).to eq(encrypted_token)
          expect(User.find(user.id).token).to be_nil
        end

        it 'returns the original value' do
          expect(user.token = unencrypted_token).to eq(unencrypted_token)
        end
      end
    end
  end

  describe 'class methods' do
    describe '.generate_token' do
      let(:random_token) { 'abc123' }

      context 'with no arguments' do
        before do
          allow(SecureRandom).to receive(:hex).and_return(random_token)
        end

        it 'returns a token when called' do
          expect(User.generate_token).to eq(random_token)
        end
      end

      context 'when passing a length' do
        it 'validates the length is coercable to an integer' do
          expect{ User.generate_token(12) }.not_to raise_error
          expect{ User.generate_token(false) }.to raise_error(ArgumentError)
        end

        it 'returns a token of that length' do
          expect(User.generate_token(20).size).to eq(20)
        end
      end
    end
  end
end
