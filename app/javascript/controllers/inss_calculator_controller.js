import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["salaryInput", "discountInput", "netSalaryInput"]

  initialize() {
    console.log("INSS Calculator inicializado!")
  }

  connect() {
    console.log("Elemento conectado:", this.element)
    console.log("Targets encontrados:", {
      salary: this.salaryInputTarget,
      discount: this.discountInputTarget,
      netSalary: this.netSalaryInputTarget
    })
  }

  calculate() {
    console.log('Calculando INSS...');
    const salary = parseFloat(this.salaryTarget.value.replace(',', '.')) || 0;
    let inss = 0;

    // Exemplo simples de cálculo INSS
    if (salary <= 1320) {
      inss = salary * 0.075;
    } else if (salary <= 2571.29) {
      inss = salary * 0.09;
    } else if (salary <= 3856.94) {
      inss = salary * 0.12;
    } else if (salary <= 7507.49) {
      inss = salary * 0.14;
    } else {
      inss = 7507.49 * 0.14; // Teto
    }

    const netSalary = salary - inss;

    this.inssDiscountTarget.value = inss.toFixed(2);
    this.netSalaryTarget.value = netSalary.toFixed(2);
  }
}