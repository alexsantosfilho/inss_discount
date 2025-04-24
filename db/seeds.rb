# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
10.times do
  Employee.create!(
    name: Faker::Name.name,
    cpf: CPF.generate,
    birth_date: rand(18..60).years.ago,
    address: Faker::Address.street_address,
    number: Faker::Address.building_number,
    district: Faker::Address.community,
    city: Faker::Address.city,
    state: 'SC',
    cep: '88000-000',
    phones_attributes: [
      { number: Faker::PhoneNumber.phone_number, phone_type: "personal" }
    ],
    salary: rand(1000.0..6000.0).round(2),
    inss_discount: 0
  )
end

Employee.find_each do |p|
  p.update(inss_discount: Inss::CalculationService.call(p.salary))
end

User.find_or_create_by!(email_address: "impulso@email.com") do |user|
  user.password = "senha1234"
  user.name = "impulso"
end
