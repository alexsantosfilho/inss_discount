import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Flash controller connected")
    setTimeout(() => {
      this.element.remove()
    }, 4000)
  }
}
