FactoryBot.define do
  factory :phone do
    phone_type { 'home' }
    number { '11987654321' }
    employee
  end
end
