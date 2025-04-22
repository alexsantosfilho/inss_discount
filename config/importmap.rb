pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "bootstrap" # @5.3.5
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.4.9/dist/chart.js"
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
pin "employees/report_chart", to: "employees/report_chart.js"
pin "controllers/inss_calculator_controller", to: "controllers/inss_calculator_controller.js"
