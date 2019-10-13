class User < ActiveRecord::Base
  has_encrypted_token
  has_encrypted_token :shared_secret
end
