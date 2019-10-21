class Model < ActiveRecord::Base; end

class User < Model
  has_protected_token
end

class SpecialUser < Model
  has_protected_token :shared_secret
end
