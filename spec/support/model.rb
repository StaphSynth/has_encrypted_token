class Model < ActiveRecord::Base; end

class User < Model
  has_encrypted_token
end

class SpecialUser < Model
  has_encrypted_token :shared_secret
end
