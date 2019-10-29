# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table :models do |t|
    t.string :shared_secret
    t.string :token
  end
end
