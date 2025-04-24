require 'rails_helper'

RSpec.describe UpdateSalaryJob, type: :job do
  include ActiveJob::TestHelper

  let(:valid_employee) { create(:employee, salary: 1000.00) }

  it "updates employee salary and inss discount" do
    new_salary = 2000.00
    expected_discount = Inss::CalculationService.call(new_salary)

    perform_enqueued_jobs do
      UpdateSalaryJob.perform_later(valid_employee.id, new_salary.to_s)
    end

    valid_employee.reload
    expect(valid_employee.salary).to eq(new_salary)
    expect(valid_employee.inss_discount).to eq(expected_discount)
  end
end
