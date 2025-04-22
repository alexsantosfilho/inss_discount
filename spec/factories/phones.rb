FactoryBot.define do
  factory :phone do
    phone_type { "MyString" }
    number { "MyString" }
    employee { nil }
  end
end
