require 'spec_helper'

describe ActiveRecord::ProtectedToken do
  let(:user) { User.create }
  let(:raw_token) { 'raw_token' }
  let(:hashed_token) { '$hashed_token$' }

  describe 'options hash' do
    describe 'column_name' do
      context 'when no value is provided' do
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

    describe 'cost' do
      context 'when no value provided' do
        it 'defaults to BCrypt::Engine::DEFAULT_COST' do
          expect(BCrypt::Password).to receive(:create).with(
            raw_token,
            cost: BCrypt::Engine::DEFAULT_COST
          )

          user.token = raw_token
        end
      end

      context 'when an integer is provided' do
        let(:user) { CostedUser.new }

        it 'accepts that instead' do
          expect(BCrypt::Password).to receive(:create).with(
            raw_token,
            cost: 9
          )

          user.token = raw_token
        end
      end
    end
  end

  context 'instance methods' do
    before do
      allow(User).to receive(:generate_token).and_return(raw_token)
      allow(BCrypt::Password).to receive(:create).and_return(hashed_token)
      allow(BCrypt::Password).to(
        receive(:new).with(hashed_token).and_return(raw_token)
      )
    end

    describe '#regenerate_{attribute}' do
      it 'returns a new token' do
        expect(user.regenerate_token).to eq(raw_token)
      end

      it 'hashes the new token and stores it in the database' do
        user.regenerate_token

        expect(user.reload.token).to eq(hashed_token)
      end
    end

    describe '#authenticate_{attribute}' do
      before do
        user.regenerate_token
      end

      context 'when passed an plain text token' do
        it 'returns true if it matches the stored value' do
          expect(user.authenticate_token(raw_token)).to eq(true)
        end

        it 'returns false if it does not match the stored value' do
          expect(user.authenticate_token('derp derp')).to eq(false)
        end
      end

      context 'when passed bad data' do
        before do
          allow(BCrypt::Password).to receive(:new).and_raise(BCrypt::Error)
        end

        it 'returns false' do
          expect(user.authenticate_token({ bad: 'data' })).to eq(false)
        end
      end
    end

    describe '#{attribute}=' do
      context 'when passed a value' do
        it 'hashes it and stores the hashed value in the model instance' do
          user.token = raw_token

          expect(user.token).to eq(hashed_token)
          expect(User.find(user.id).token).to be_nil
        end

        it 'returns the original value' do
          expect(user.token = raw_token).to eq(raw_token)
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
