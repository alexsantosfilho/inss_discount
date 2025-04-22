import { Chart } from 'chart.js'

document.addEventListener('turbo:load', () => {
  const ctx = document.getElementById('salaryChart');
  
  if (ctx) {
    const data = JSON.parse(ctx.dataset.chartData);
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: data.labels,
        datasets: [{
          label: 'Funcionários por Faixa Salarial',
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
    });
  }
});