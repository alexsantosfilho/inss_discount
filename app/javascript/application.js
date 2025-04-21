// app/javascript/application.js

import "@hotwired/turbo-rails"
import "./controllers"            // prefixo "./" para arquivos locais
import "bootstrap"                // pacote npm do Bootstrap (já instalado)
import Chart from "chart.js/auto" // pacote npm do Chart.js

window.Chart = Chart;
import * as bootstrap from "bootstrap";
