// import Chart from 'chart.js/auto';

// document.addEventListener('DOMContentLoaded', () => {
//   const chartElement = document.getElementById('salary-discount-chart');
//   if (!chartElement) return;

//   const labels = JSON.parse(chartElement.dataset.labels);
//   const data = JSON.parse(chartElement.dataset.data);

//   new Chart(chartElement, {
//     type: 'bar',
//     data: {
//       labels: labels,
//       datasets: [{
//         label: 'Proponents per Salary Range',
//         data: data,
//         backgroundColor: [
//           '#4e73df',
//           '#1cc88a',
//           '#36b9cc',
//           '#f6c23e'
//         ],
//         borderWidth: 1
//       }]
//     },
//     options: {
//       scales: {
//         y: {
//           beginAtZero: true,
//           stepSize: 1
//         }
//       }
//     }
//   });
// });
import Chart from 'chart.js/auto';
document.addEventListener('DOMContentLoaded', () => {
  const ctx = document.getElementById('salary-chart');
  if (!ctx) return;
  const labels = JSON.parse(ctx.dataset.labels);
  const values = JSON.parse(ctx.dataset.values);

  new Chart(ctx, {
    type: 'bar',
    data: { labels, datasets: [{ label: 'Proponentes por faixa salarial', data: values }] },
  });
});