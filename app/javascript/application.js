import "@hotwired/turbo-rails"
import "@rails/actioncable"

// Inicializa Stimulus
import { Application } from "@hotwired/stimulus"
const application = Application.start()
window.Stimulus = application

// Autoload de controllers
import "./controllers"
import "./employees/report_chart"
import "./controllers/inss_calculator_controller"
// import "./charts/report_chart"
// Bootstrap (com Popper)
import "@popperjs/core"
import "bootstrap"
import "bootstrap/dist/css/bootstrap.min.css"

// Chart.js (com dependência de cor)
import "@kurkle/color"
import { Chart } from "chart.js"

// Debug (verifique no console do navegador)
console.log("Stimulus carregado:", application)
// console.log("Bootstrap carregado:", typeof bootstrap)
console.log("Chart.js carregado:", typeof Chart)