import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="body"
export default class extends Controller {
  connect() {
    console.log("HI!");
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))    
  }
}
