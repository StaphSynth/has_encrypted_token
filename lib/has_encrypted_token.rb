require 'active_record'
require 'bcrypt'

module ActiveRecord
  module EncryptedToken
    extend ActiveSupport::Concern

    module ClassMethods
      def has_encrypted_token(attribute = :token)
        define_method("regenerate_#{attribute}") do
          unencrypted_token = self.class.generate_token
          encrypted_token = encrypt_token(unencrypted_token)

          update_attribute(attribute, encrypted_token)
          unencrypted_token
        end

        define_method("#{attribute}=") do |unencrypted_token|
          super(encrypt_token(unencrypted_token))
        end

        define_method("authenticate_#{attribute}") do |unencrypted_token|
          begin
            BCrypt::Password.new(self.send(attribute)) == unencrypted_token
          rescue BCrypt::Error
            false
          end
        end
      end

      def generate_token(length = 48)
        begin
          n = length.to_i
        rescue NoMethodError
          raise ArgumentError, 'Token length must be an integer'
        end

        SecureRandom.hex(n / 2) # hex returns n * 2
      end
    end

    private

    def encrypt_token(unencrypted_token)
      BCrypt::Password.create(
        unencrypted_token,
        :cost => BCrypt::Engine::DEFAULT_COST
      )
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::EncryptedToken)
