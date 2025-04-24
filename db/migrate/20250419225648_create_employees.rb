class CreateEmployees< ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :cpf
      t.date :birth_date
      t.string :address
      t.string :city
      t.string :state
      t.string :cep
      t.text :phones
      t.decimal :salary, precision: 10, scale: 2
      t.decimal :inss_discount, precision: 10, scale: 2
      t.timestamps
    end
  end
end
