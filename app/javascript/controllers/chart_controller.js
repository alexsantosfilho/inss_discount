// app/javascript/controllers/chart_controller.js
import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    this.initializeChart()
  }

  initializeChart() {
    const ctx = this.element
    const data = this.dataValue
    
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: data.labels,
        datasets: [{
          label: data.label || 'Dados',
          data: data.values,
          backgroundColor: 'rgba(54, 162, 235, 0.5)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    })
  }
}