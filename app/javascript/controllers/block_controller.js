import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="block"
export default class extends Controller {
  static targets = ["editor"]

  edit() {
    this.element.querySelector("[data-block-target='editor']").classList.remove('hidden')
    this.element.querySelector("[data-action='click->block#edit']").classList.add('hidden')
  }

  add() {
    this.element.querySelector("[data-block-target='new-block-form']").classList.remove('hidden')
  }
}
