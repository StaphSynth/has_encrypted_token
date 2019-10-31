# frozen_string_literal: true

require 'spec_helper'

describe 'token authentication' do
  let(:user) { User.create }

  describe 'for locally generated tokens' do
    describe 'when presented with the correct secret value' do
      it 'returns true' do
        secret = user.regenerate_token

        expect(user.authenticate_token(secret)).to eq(true)
      end
    end

    describe 'when presented with the incorrect secret value' do
      it 'returns false' do
        user.regenerate_token

        expect(user.authenticate_token('derp derp')).to eq(false)
      end
    end
  end

  describe 'for user-supplied tokens' do
    before do
      user.token = 'trains'
    end

    describe 'when presented with the correct secret value' do
      it 'returns true' do
        expect(user.authenticate_token('trains')).to eq(true)
      end
    end

    describe 'when presented with the incorrect secret value' do
      it 'returns false' do
        expect(user.authenticate_token('buses')).to eq(false)
      end
    end
  end
end
