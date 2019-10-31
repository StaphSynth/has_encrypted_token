# frozen_string_literal: true

class Model < ActiveRecord::Base; end

class User < Model
  has_protected_token
end

class SpecialUser < Model
  has_protected_token column_name: :shared_secret
end

class LowCostUser < Model
  has_protected_token cost: 4
end
