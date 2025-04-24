class AddUidAndProviderToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :uid
      t.string :provider
    end
  end
end
