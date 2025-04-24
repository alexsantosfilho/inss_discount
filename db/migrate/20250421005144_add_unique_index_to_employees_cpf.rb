class AddUniqueIndexToEmployeesCpf < ActiveRecord::Migration[8.0]
  def change
       add_index :employees, :cpf, unique: true
  end
end
