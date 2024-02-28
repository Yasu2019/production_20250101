# frozen_string_literal: true

# comment
class AddTokenCreatedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :token_created_at, :datetime
  end
end
