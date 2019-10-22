class Model < ActiveRecord::Base; end

class User < Model
  has_protected_token
end

class SpecialUser < Model
  has_protected_token column_name: :shared_secret
end

class CostedUser < Model
  has_protected_token cost: 9
end
