import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["salaryInput", "discountInput", "netSalaryInput"]

  connect() {
    if (this.salaryInputTarget.value) {
      this.calculate()
    }
  }

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

  clearValues() {
    this.discountInputTarget.value = ""
    this.netSalaryInputTarget.value = ""
  }
}