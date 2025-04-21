class Employee < ApplicationRecord
  validates :name, :cpf, :birth_date, :address,
            :city, :state, :cep, :salary, presence: true

  validates :cpf, uniqueness: true

  validates :cep, format: { with: /\A\d{5}-\d{3}\z/ }
  validates :salary, numericality: { greater_than: 0 }

  def self.salary_ranges_report
    ranges = {
      "Até R$ 1.045,00" => where("salary <= ?", 1045.00),
      "De R$ 1.045,01 a R$ 2.089,60" => where("salary > ? AND salary <= ?", 1045.00, 2089.60),
      "De R$ 2.089,61 até R$ 3.134,40" => where("salary > ? AND salary <= ?", 2089.60, 3134.40),
      "De R$ 3.134,41 até R$ 6.101,06" => where("salary > ? AND salary <= ?", 3134.40, 6101.06)
    }

    ranges.transform_values(&:count)
  end
end
