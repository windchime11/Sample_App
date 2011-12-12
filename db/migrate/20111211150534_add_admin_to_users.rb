class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    # without :default => false, admin will be nil by default as well
    add_column :users, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :admin
  end
end
