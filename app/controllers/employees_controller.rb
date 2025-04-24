class EmployeesController < ApplicationController
  before_action :set_employee, only: [ :show, :edit, :update, :destroy, :update_salary ]

  def index
    @employees = Employee.order(updated_at: :desc).page(params[:page]).per(5)
  end

  def show
  end

  def new
    @employee = Employee.new
    @employee.phones.build
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employees_path, notice: "Proponente criado com sucesso."
    else
      flash.now[:alert] = "Erro ao salvar: #{@employee.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity  # Status 422 para Turbo Stream
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: "Proponente atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_url, notice: "Proponente removido com sucesso."
  end

  def report
    @ranges_data = Employee.salary_ranges_report
    puts @ranges_data.inspect
  end

  def calculate_inss_discount
    salary = params[:salary].to_f
    inss_discount = Inss::CalculationService.call(salary)

    render json: {
      inss_discount: inss_discount,
      net_salary: salary - inss_discount
    }
  end

  def update_salary
    @employee = Employee.find(params[:id])
    respond_to do |format|
      format.html do
        redirect_to employees_path, notice: "Salário em atualização via job..."
      end

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "employee_#{@employee.id}",
            partial: "employees/status_processing",
            locals: { employee: @employee }
          )
        ]
      end
    end

    UpdateSalaryJob.perform_later(@employee.id, params[:salary])
  end


  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :name, :cpf, :birth_date, :salary, :inss_discount,
      :address, :number, :district, :city, :state, :cep,
      phones_attributes: [ :id, :phone_type, :number, :_destroy ]
    )
  end
end
