require 'active_record'
require 'bcrypt'

module ActiveRecord
  module ProtectedToken
    extend ActiveSupport::Concern

    module ClassMethods
      # == has_protected_token
      #
      # Adds methods to set and validate against a token
      # that has been hashed and salted using BCrypt.
      # It assumes you have a 'token' attribute on
      # your model.
      #
      # === Options
      #
      # +has_protected_token+ accepts an optional hash
      # for modifying the following default behaviour:
      #
      # +column_name+
      # If you would like to use an attribute other than
      # 'token', pass +column_name: :my_attribute_name+
      #
      # +cost+
      # BCrypt's default hashing cost is used. To use a
      # different value, pass +cost: <value>+. The cost
      # value must be an integer.
      #
      # === Example 1
      #
      # Generating a new token on the fly.
      #
      # class UserOne < ActiveRecord::Base
      #   has_protected_token column_name: :shared_secret, cost: 8
      # end
      #
      # user1 = UserOne.new
      # user1.regenerate_shared_secret
      # => 'e13d0bbd4a12d2aea673127c7e995a67'
      #
      # user1.authenticate_shared_secret('not_even_close_to_correct')
      # => false
      #
      # user1.authenticate_shared_secret('e13d0bbd4a12d2aea673127c7e995a67')
      # => true
      #
      # === Example 2
      #
      # Passing your own token.
      #
      # class UserTwo < ActiveRecord::Base
      #   has_protected_token cost: 8
      # end
      #
      # user2 = UserTwo.new
      # user2.token = 'super_secret_token'
      # => 'super_secret_token'
      # user2.save!
      # => true
      # user2.token
      # => '$2a$12$5xVuny6Z79bYfgMMU7nyzeaOSjygRnXfsJjeJHzRZ0vUYRGeUjo6u'
      #
      # user2.authenticate_token('totally_wrong')
      # => false
      #
      # user2.authenticate_token('super_secret_token')
      # => true
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

      # == .generate_token
      # Class method to generate random tokens
      #
      # Accepts an optional integer to specify the length
      # of the returned token.
      def generate_token(length = 24)
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
