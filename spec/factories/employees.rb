FactoryBot.define do
  factory :employee do
    name { "John Doe" }
    cpf { CPF.generate }
    birth_date { 30.years.ago.to_date }
    salary { 3000.00 }
    address { "123 Main St" }
    number { "10" }
    district { "Center" }
    city { "Example City" }
    state { "SP" }
    cep { "12345-678" }
    inss_discount { 281.63 }

    trait :with_phone do
      after(:build) do |employee|
        employee.phones << build(:phone, employee: employee)
      end
    end
  end
end
