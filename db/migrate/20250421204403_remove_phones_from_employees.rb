class RemovePhonesFromEmployees < ActiveRecord::Migration[8.0]
  def change
    remove_column :employees, :phones, :text
  end
end
