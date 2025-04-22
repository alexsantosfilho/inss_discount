// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import ChartController from "./chart_controller"
application.register("chart", ChartController)

eagerLoadControllersFrom("controllers", application)
