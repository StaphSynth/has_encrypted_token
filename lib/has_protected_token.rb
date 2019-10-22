require 'active_record'
require 'bcrypt'

module ActiveRecord
  module ProtectedToken
    extend ActiveSupport::Concern

    module ClassMethods
      def has_protected_token(options = {})
        attribute = options[:column_name] || :token
        cost = options[:cost] || BCrypt::Engine::DEFAULT_COST

        define_method("regenerate_#{attribute}") do
          raw_token = self.class.generate_token
          hashed_token = hash_token(raw_token, cost)

          update_attribute(attribute, hashed_token)
          raw_token
        end

        define_method("#{attribute}=") do |raw_token|
          super(hash_token(raw_token, cost))
        end

        define_method("authenticate_#{attribute}") do |raw_token|
          begin
            BCrypt::Password.new(self.send(attribute)) == raw_token
          rescue BCrypt::Error
            false
          end
        end
      end

      def generate_token(length = 48)
        n = length.to_i
        SecureRandom.hex(n / 2) # hex returns n * 2

        rescue NoMethodError
          raise ArgumentError, 'Token length must be an integer'
      end
    end

    private

    def hash_token(raw_token, cost)
      BCrypt::Password.create(raw_token, :cost => cost)
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::ProtectedToken)
