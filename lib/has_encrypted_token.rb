require 'active_record'
require 'bcrypt'

module ActiveRecord
  module EncryptedToken
    extend ActiveSupport::Concern

    module ClassMethods
      def has_encrypted_token(attribute = :token)
        define_method("regenerate_#{attribute}") do
          unencrypted_token = self.class.generate_token
          encrypted_token = BCrypt::Password.create(
            unencrypted_token,
            :cost => BCrypt::Engine::DEFAULT_COST
          )

          update_attribute(attribute, encrypted_token)
          unencrypted_token
        end

        define_method("authenticate_#{attribute}") do |unencrypted_token|
          begin
            BCrypt::Password.new(self.send(attribute)) == unencrypted_token
          rescue BCrypt::Errors::InvalidHash
            false
          end
        end
      end

      def generate_token
        SecureRandom.hex(24)
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::EncryptedToken)
