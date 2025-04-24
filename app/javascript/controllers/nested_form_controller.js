import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "phone"]

  add(e) {
    e.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.element.insertAdjacentHTML('beforeend', content)
  }

  remove(e) {
    e.preventDefault()
    const wrapper = e.target.closest("[data-nested-form-target='phone']")
    if (wrapper) {
      const destroyInput = wrapper.querySelector("input[name*='_destroy']")
      if (destroyInput) {
        destroyInput.value = "1"
        wrapper.style.display = 'none'
      } else {
        wrapper.remove()
      }
    }
  }
}