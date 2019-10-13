ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :shared_secret
    t.string :token
  end
end
