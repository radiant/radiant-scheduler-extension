class AddScheduleFields < ActiveRecord::Migration
  def self.up
    add_column :pages, :appears_on, :date
    add_column :pages, :expires_on, :date
  end
  
  def self.down
    remove_column :pages, :appears_on
    remove_column :pages, :expires_on
  end
end
