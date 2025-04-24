class Employee < ApplicationRecord
  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  after_update_commit :broadcast_replace

  validates :name, :cpf, :birth_date, :address,
            :city, :state, :cep, :salary, presence: true

  validates :cpf, uniqueness: true
  validates :cep, format: { with: /\A\d{5}-\d{3}\z/ }
  validates :salary, numericality: { greater_than: 0 }
  validates :number, presence: true
  validates :district, presence: true


  def self.salary_ranges_report
    ranges = {
      "Até R$ 1.045,00" => where("salary <= ?", 1045.00),
      "De R$ 1.045,01 a R$ 2.089,60" => where("salary > ? AND salary <= ?", 1045.00, 2089.60),
      "De R$ 2.089,61 até R$ 3.134,40" => where("salary > ? AND salary <= ?", 2089.60, 3134.40),
      "De R$ 3.134,41 até R$ 6.101,06" => where("salary > ? AND salary <= ?", 3134.40, 6101.06)
    }

    counts = ranges.transform_values(&:count)  # Contando os proponentes por faixa salarial
    total = counts.values.sum  # Calculando o total de proponentes

    ranges_data = counts.map do |label, count|
      {
        label: label,
        count: count,
        percentage: total > 0 ? (count.to_f / total * 100) : 0
      }
    end

    ranges_data
  end

  private

  def broadcast_replace
    Turbo::StreamsChannel.broadcast_replace_to(
      "employees",
      target: ActionView::RecordIdentifier.dom_id(self),
      partial: "employees/employee",
      locals: { employee: self }
    )
  end
end
