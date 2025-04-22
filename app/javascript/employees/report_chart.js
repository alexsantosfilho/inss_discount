
// import { Chart } from 'chart.js/auto';

const initSalaryChart = () => {
  console.log("Iniciando o gráfico de salários...")
  if (typeof Chart === 'undefined') {
    console.error("Chart.js não está carregado.")
    return
  }
  console.log("Chart.js carregado:", typeof Chart)

  const ctx = document.getElementById('salaryChart')
  if (!ctx) return // Sai se não encontrar o elemento

  // Verifica se os atributos de dados estão definidos
  const labels = ctx.dataset.labels;
  const values = ctx.dataset.values;

  if (!labels || !values) {
    console.error('Faltam os dados dos rótulos ou valores!');
    return;
  }

  try {
    // Tenta analisar os dados, e se falhar, mostra um erro
    const chartData = {
      labels: JSON.parse(labels),
      datasets: [{
        label: 'Proponentes por Faixa Salarial',
        data: JSON.parse(values),
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
  } catch (error) {
    console.error('Erro ao analisar os dados:', error);
  }
}


// Adiciona os event listeners para Turbo Rails
document.addEventListener('turbo:load', initSalaryChart)
document.addEventListener('turbo:render', initSalaryChart)