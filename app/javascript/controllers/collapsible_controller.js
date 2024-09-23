import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collapsible"
export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
  }
}
