describe 'CPF uniqueness' do
  let!(:existing_employee) { create(:employee) } # This creates a valid employee

  it 'validates uniqueness case-insensitively' do
    new_employee = build(:employee, cpf: existing_employee.cpf.upcase)
    expect(new_employee).to be_invalid
    expect(new_employee.errors[:cpf]).to include('has already been taken')
  end
end
