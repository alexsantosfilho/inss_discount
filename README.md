# Desafio Rails 8 - Cálculo de Desconto INSS

## Descrição do Projeto

Aplicação Rails 8 completa para gestão de proponentes com cálculo automático de INSS, utilizando o ecossistema moderno de desenvolvimento incluindo Hotwire, Action Cable e o sistema de autenticação integrado do Rails 8.

## Estrutura do Projeto (Atualizada para Rails 8)

```
.
├── assets/
│   ├── builds/               # Assets compilados
│   ├── config/               # Configuração de assets
│   ├── images/               # Imagens
│   └── stylesheets/          # Estilos (Sass/SCSS)
├── channels/                 # Action Cable
│   ├── application_cable/    # Config base
│   └── employees_channel.rb  # Canal para atualizações
├── controllers/
│   ├── concerns/             # Concerns compartilhados
│   ├── employees_controller.rb # Controller principal
│   ├── reports_controller.rb # Relatórios
│   └── sessions_controller.rb # Autenticação
├── helpers/                  # Helpers
├── javascript/
│   ├── channels/             # Consumers Action Cable
│   ├── controllers/          # Stimulus controllers
│   └── employees/            # JS específico
├── jobs/                     # Background jobs
├── mailers/                  # Email
├── models/
│   ├── concerns/             # Model concerns
│   ├── current.rb            # Current pattern
│   ├── employee.rb           # Model principal
│   └── user.rb               # Autenticação
├── services/                 # Lógica de negócio
│   └── inss/                 # Cálculo de INSS
├── views/
│   ├── employees/            # Views turbo frames
│   ├── layouts/              # Layouts
│   ├── reports/              # Relatórios
│   └── sessions/             # Login
```

## Tecnologias Principais

### Rails 8 Stack
- **Hotwire**: Turbo Drive, Frames e Streams
- **Stimulus**: Controllers JS modernos
- **Action Cable**: Atualizações em tempo real
- **Authentication**: Sistema nativo do Rails 8

### Frontend Moderno
- `@hotwired/turbo-rails` 2.x
- `@hotwired/stimulus` 1.3.4
- `esbuild` para bundling
- `Bootstrap 5.3.5` com dark mode
- `Chart.js` 4.x com integração Stimulus

### Backend
- Rails 8 (edge)
- PostgreSQL 15+
- Redis 7+ (Action Cable + Sidekiq)
- Sidekiq 8.0.2 (jobs assíncronos)

## Configuração do Ambiente

### Pré-requisitos
- Ruby 3.3+
- Rails 8.0.2
- Node.js 20+
- PostgreSQL 15+
- Redis 7+

### Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/desconto-inss.git
   cd desconto-inss
   ```

2. Configure o ambiente:
   ```bash
   cp .env.example .env
   ```

3. Instale dependências:
   ```bash
   bundle install
   yarn install
   ```

4. Prepare o banco:
   ```bash
   rails db:prepare
   rails db:seed
   ```

5. Inicie o servidor:
   ```bash
   bin/dev
   ```


### Cálculo de INSS com Turbo Streams
```ruby
# controllers/employees_controller.rb
def calculate_inss_discount
    salary = params[:salary].to_f
    inss_discount = Inss::CalculationService.call(salary)

    render json: {
      inss_discount: inss_discount,
      net_salary: salary - inss_discount
    }
end
```

```erb
<%# views/employees/_salary_form.html.erb %>
<%= turbo_frame_tag "salary_update_#{employee.id}" do %>
  <div class="d-flex gap-2 align-items-center">
    <%= form_with url: update_salary_employee_path(employee), method: :patch, data: { turbo: true } do |form| %>
      <%= form.label :salary, "Novo salário:", class: "mb-0" %>
      <%= form.number_field :salary, step: 0.01, required: true, class: "form-control w-auto" %>
      <%= form.submit "Atualizar via", class: "btn btn-sm btn-outline-success" %>
    <% end %>
    <div id="employee_<%= employee.id %>_status"></div>
  </div>
<% end %>
```

## Padrões de Código

### Services
```ruby
# services/inss/calculation_service.rb
module Inss
  class CalculationService
    TAX_RANGES = [
      { min: 0.0, max: 1045.00, rate: 0.075 },
      { min: 1045.01, max: 2089.60, rate: 0.09 },
      { min: 2089.61, max: 3134.40, rate: 0.12 },
      { min: 3134.41, max: 6101.06, rate: 0.14 }
    ].freeze

    def self.call(salary)
      new(salary).calculate
    end

    def initialize(salary)
      @salary = salary.to_f
    end

    def calculate
      # Lógica de cálculo progressivo
    end
  end
end

```

### Stimulus Controllers
```javascript
// javascript/controllers/inss_calculator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["salaryInput", "discountInput", "netSalaryInput"]

  calculate() {
    const salary = parseFloat(this.salaryInputTarget.value)

    if (!salary || isNaN(salary)) {
      this.clearValues()
      return
    }

    this.discountInputTarget.value = "Calculando..."
    this.netSalaryInputTarget.value = "Calculando..."

    fetch(`/employees/calculate_inss_discount?salary=${salary}`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Erro na requisição")
        }
        return response.json()
      })
      .then(data => {
        this.discountInputTarget.value = data.inss_discount.toFixed(2)
        this.netSalaryInputTarget.value = data.net_salary.toFixed(2)
      })
      .catch(error => {
        console.error("Error calculating INSS:", error)
        this.clearValues()
        this.discountInputTarget.value = "Erro no cálculo"
        this.netSalaryInputTarget.value = "Erro no cálculo"
      })
  }
```

## Testes

Sistema de testes completo com:
spec/
├── channels/                    # Testes de Action Cable
├── controllers/
│   └── employees_controller_spec.rb  # Testes do controller principal
├── factories/                   # Factories para testes
│   ├── employees.rb             # Factory de proponentes
│   ├── phones.rb                # Factory de telefones
│   ├── sessions.rb              # Factory de sessões
│   └── users.rb                 # Factory de usuários
├── jobs/
│   └── update_salary_job_spec.rb # Testes de background jobs
├── models/                      # Testes de modelos
│   ├── current_spec.rb          # Testes do padrão Current
│   ├── employee_spec.rb         # Testes do modelo Employee
│   ├── session_spec.rb          # Testes de sessão
│   └── user_spec.rb             # Testes de usuário
├── requests/
│   └── sessions_spec.rb         # Testes de requisição de autenticação
├── services/
│   └── inss/
│       └── calculation_service_spec.rb # Testes do serviço de cálculo
├── rails_helper.rb              # Configuração do RSpec
├── spec_helper.rb               # Configuração base
└── support/                     # Helpers de teste
    ├── action_cable_helper.rb    # Suporte para Action Cable
    └── authentication_helper.rb  # Helpers de autenticação

Execute com:
```bash
bundle exec rspec
```

---

O projeto foi desenvolvido utilizando as tecnologias mais modernas do ecossistema Ruby on Rails, demonstrando domínio completo da stack atual, incluindo Hotwire, Action Cable e o novo sistema de autenticação introduzido no Rails 8. Apesar de algumas melhorias ainda poderem ser implementadas — como uma melhor estruturação de pastas, versionamento e organização, especialmente na camada de JavaScript — o foco principal foi evidenciar minha capacidade full stack com Rails. Além disso, planejava incluir a documentação da API utilizando o Rswag, pra uma comunicação clara e padronizada para desenvolvedores.

