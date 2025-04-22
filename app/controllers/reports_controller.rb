class ReportsController < ApplicationController
  def salary_ranges
    @ranges_data = Employee.salary_ranges_report
    respond_to do |format|
      format.html
      format.json { render json: @ranges_data }
    end
  end
end
