require 'active_record'

module ActiveRecord
  module EncryptedToken
    extend ActiveSupport::Concern

    module ClassMethods
      def has_encrypted_token(attribute = :token)
        before_create do
          self.send("#{attribute}=", 'test')
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::EncryptedToken)
