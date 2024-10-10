import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="command"
export default class extends Controller {
  connect() {
    this.selected = ""
    this.items = this.data.element.querySelectorAll("li")
  }

  keyDown(event) {
    const active = document.activeElement
    const isActiveLI = active.tagName === "LI"
    if (event.key === "ArrowDown") {
      if (isActiveLI) {
        const nextElement = active.nextElementSibling ? active.nextElementSibling : this.items[0]
        nextElement.focus()
      } else {
        this.focusFirstElement()
      }
    } else if (event.key === "ArrowUp") {
      if (isActiveLI) {
        const prevElement = active.previousElementSibling ? active.previousElementSibling : this.items[this.items.length - 1]
        prevElement.focus()
      } else {
        this.focusFirstElement()
      }
    }
  }

  focusFirstElement() {
    this.items[0].focus()
  }

  filter(event) {
    const value = event.target.value
    this.items.forEach((item) => {
      if (item.textContent.toLowerCase().includes(value.replace("/", "").toLowerCase())) {
        item.classList.remove("hidden")
      } else {
        item.classList.add("hidden")
      }
    })
  }
}
