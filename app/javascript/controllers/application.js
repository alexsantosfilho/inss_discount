import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Chart } from "chart.js"
window.Chart = Chart

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// Importa todos os controladores automaticamente
eagerLoadControllersFrom("controllers", application)

export { application }
