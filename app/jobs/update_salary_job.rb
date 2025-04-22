class UpdateSalaryJob < ApplicationJob
  include ActionView::RecordIdentifier
  queue_as :default

  def perform(employee_id, new_salary)
    employee = Employee.find(employee_id)
    employee.update(
      salary: new_salary,
      inss_discount: Inss::CalculationService.call(new_salary)
    )
  end
end
