
import { Chart } from 'chart.js'

const initSalaryChart = () => {

  if (typeof Chart === 'undefined') {
    console.error("Chart.js não está carregado.")
    return
  }
  console.log("Chart.js carregado:", typeof Chart)
  const ctx = document.getElementById('salaryChart')
  
  if (!ctx) return // Sai se não encontrar o elemento

  // Os dados agora virão de data attributes
  const chartData = {
    labels: JSON.parse(ctx.dataset.labels),
    datasets: [{
      label: 'Proponentes por Faixa Salarial',
      data: JSON.parse(ctx.dataset.values),
      backgroundColor: [
        'rgba(255, 99, 132, 0.7)',
        'rgba(54, 162, 235, 0.7)',
        'rgba(255, 206, 86, 0.7)',
        'rgba(75, 192, 192, 0.7)'
      ],
      borderWidth: 1
    }]
  }

  new Chart(ctx, {
    type: 'bar',
    data: chartData,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            stepSize: 1
          }
        }
      }
    }
  })
}

// Adiciona os event listeners para Turbo Rails
document.addEventListener('turbo:load', initSalaryChart)
document.addEventListener('turbo:render', initSalaryChart)