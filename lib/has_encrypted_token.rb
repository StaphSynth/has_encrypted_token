require 'active_record'

module ActiveRecord
  module EncryptedToken
    module ClassMethods
      def has_encrypted_token(attribute = :token)

      end
    end
  end
end
