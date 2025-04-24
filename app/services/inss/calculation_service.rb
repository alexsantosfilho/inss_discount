module Inss
  class CalculationService
    TAX_RANGES = [
      { min: 0.0, max: 1045.00, rate: 0.075 },
      { min: 1045.01, max: 2089.60, rate: 0.09 },
      { min: 2089.61, max: 3134.40, rate: 0.12 },
      { min: 3134.41, max: 6101.06, rate: 0.14 }
    ].freeze

    def self.call(salary)
      new(salary).calculate
    end

    def initialize(salary)
      @salary = salary.to_f
    end

    def calculate
      discount = 0.0

      TAX_RANGES.each do |range|
        break if @salary <= range[:min]

        taxable_amount = [ @salary, range[:max] ].min - range[:min]
        discount += taxable_amount * range[:rate]
      end

      discount.round(2)
    end
  end
end
