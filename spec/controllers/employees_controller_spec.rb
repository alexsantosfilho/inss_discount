require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) {
    {
      name: "John Doe",
      cpf: "123.456.789-09",
      birth_date: "1990-01-01",
      salary: 3000.00,
      address: "123 Main St",
      number: "10",
      district: "Center",
      city: "Example City",
      state: "SP",
      cep: "12345-678",
      phones_attributes: [ {
        phone_type: "reference",
        number: "1234567890"
      } ]
    }
  }

  let(:invalid_attributes) {
    { name: nil, cpf: nil }
  }

  let(:employee) { create(:employee) }

  before do
    @user = User.create!(
      email_address: "email@email.com",
      password: "senha1234"
    )

    @session = @user.sessions.create!(
      user_agent: "RSpec Test",
      ip_address: "127.0.0.1"
    )

    cookies.signed[:session_id] = @session.id
  end

  describe "GET #index" do
  it "returns 5 employees on first page" do
    6.times { create(:employee) }
    get :index
    employees = controller.instance_variable_get(:@employees)
    expect(employees.count).to eq(5)  # Check the number of items
    expect(employees.limit_value).to eq(5)  # Check the pagination limit
  end

  it "has pagination methods" do
    get :index
    employees = controller.instance_variable_get(:@employees)
    expect(employees).to respond_to(:total_pages)
    expect(employees).to respond_to(:current_page)
    expect(employees).to respond_to(:limit_value)
  end
end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: employee.id }
      expect(response).to be_successful
    end

    it "assigns the requested employee" do
      get :show, params: { id: employee.id }
      expect(assigns(:employee)).to eq(employee)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end

    it "builds a new employee" do
      get :new
      expect(assigns(:employee)).to be_a_new(Employee)
    end

    it "builds a phone" do
      get :new
      expect(assigns(:employee).phones.size).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Employee" do
        expect {
          post :create, params: { employee: valid_attributes }
        }.to change(Employee, :count).by(1)
      end

      it "redirects to employees list" do
        post :create, params: { employee: valid_attributes }
        expect(response).to redirect_to(employees_path)
      end

      it "sets flash notice" do
        post :create, params: { employee: valid_attributes }
        expect(flash[:notice]).to eq("Proponente criado com sucesso.")
      end
    end

    context "with invalid params" do
      it "does not create employee" do
        expect {
          post :create, params: { employee: invalid_attributes }
        }.not_to change(Employee, :count)
      end

      it "renders new with unprocessable entity status" do
        post :create, params: { employee: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end

      it "sets flash alert with errors" do
        post :create, params: { employee: invalid_attributes }
        expect(flash[:alert]).to include("Erro ao salvar")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "New Name" } }

      it "updates the employee" do
        put :update, params: { id: employee.id, employee: new_attributes }
        employee.reload
        expect(employee.name).to eq("New Name")
      end

      it "redirects to employees list" do
        put :update, params: { id: employee.id, employee: valid_attributes }
        expect(response).to redirect_to(employees_path)
      end

      it "sets flash notice" do
        put :update, params: { id: employee.id, employee: valid_attributes }
        expect(flash[:notice]).to eq("Proponente atualizado com sucesso.")
      end
    end

    context "with invalid params" do
      it "does not update employee" do
        put :update, params: { id: employee.id, employee: invalid_attributes }
        employee.reload
        expect(employee.name).not_to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the employee" do
      employee # create the employee
      expect {
        delete :destroy, params: { id: employee.id }
      }.to change(Employee, :count).by(-1)
    end

    it "redirects to employees list" do
      delete :destroy, params: { id: employee.id }
      expect(response).to redirect_to(employees_url)
    end

    it "sets flash notice" do
      delete :destroy, params: { id: employee.id }
      expect(flash[:notice]).to eq("Proponente removido com sucesso.")
    end
  end

  describe "GET #report" do
    it "returns a success response" do
      get :report
      expect(response).to be_successful
    end

    it "assigns ranges data" do
      create(:employee, salary: 1000)
      create(:employee, salary: 2000)
      get :report
      expect(assigns(:ranges_data)).to be_a(Array)
      expect(assigns(:ranges_data)).not_to be_empty
    end
  end

  describe "POST #calculate_inss_discount" do
    it "returns JSON response" do
      post :calculate_inss_discount, params: { salary: 3000 }, format: :json
      expect(response.content_type).to include('application/json')
    end

    it "calculates correct values" do
      post :calculate_inss_discount, params: { salary: 3000 }, format: :json
      json = JSON.parse(response.body)
      expect(json["inss_discount"]).to eq(281.63)
      expect(json["net_salary"]).to eq(2718.37)
    end

    it "handles zero salary" do
      post :calculate_inss_discount, params: { salary: 0 }, format: :json
      json = JSON.parse(response.body)
      expect(json["inss_discount"]).to eq(0.0)
    end
  end

  describe "POST #update_salary" do
    context "with HTML format" do
      it "redirects to employees path" do
        post :update_salary, params: { id: employee.id, salary: 4000 }
        expect(response).to redirect_to(employees_path)
      end

      it "sets flash notice" do
        post :update_salary, params: { id: employee.id, salary: 4000 }
        expect(flash[:notice]).to include("atualização via job")
      end
    end

    context "with Turbo Stream format" do
      it "returns turbo stream" do
        post :update_salary, params: { id: employee.id, salary: 4000 }, format: :turbo_stream
        expect(response.media_type).to eq(Mime[:turbo_stream])
      end
    end

    it "enqueues UpdateSalaryJob" do
      expect {
        post :update_salary, params: { id: employee.id, salary: 4000 }
      }.to have_enqueued_job(UpdateSalaryJob).with(employee.id, "4000")
    end
  end
end
