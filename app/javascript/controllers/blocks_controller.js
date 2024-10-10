import { Controller } from "@hotwired/stimulus"

function debounce(fn, ms) {
  let timeout;

  return (...args) => {
    clearTimeout(timeout)
    timeout = setTimeout(() => {
      fn(...args)
    }, ms)
  }
}

function fetchAndTurboRender(url, init, callback) {
  const element = document.head.querySelector(`meta[name="csrf-token"]`)
  const csrf = element.getAttribute("content")

  fetch(url, {
    method: init.method,
    headers: {
      'X-CSRF-Token': csrf,
      'Content-Type': 'application/json',
      'Accept': 'text/vnd.turbo-stream.html'
    },
    body: JSON.stringify(init.body)
  }).then((data) => data.text()).then((html) => {
    if (html) {
      Turbo.renderStreamMessage(html)
    }
    if (callback) {
      setTimeout(callback)
    }
  })
}

export default class extends Controller {
  static targets = ["block", "content", "slashMenu", "pageTitle"]

  connect() {
    // Initialize variables or state if needed
    this.workspaceId = this.data.element.dataset.blocksWorkspaceId
    this.pageId = this.data.element.dataset.blocksPageId
  }

  // Method to update block content
  updateContent = debounce((event) => {
    const blockElement = event.target.closest('.block')
    const blockId = blockElement.dataset.blockId
    const content = event.target.innerHTML.trim()

    // Delete block if deleted last piece of content 
    if (event.key === "Backspace" && !content) {
      this.deleteBlock(event)
      return;
    }

    fetchAndTurboRender(`/workspaces/${this.workspaceId}/pages/${this.pageId}/blocks/${blockId}`, {
      method: 'PATCH',
      body: {
        block: {
          content: content
        }
      }
    })
  }, 200)

  deleteBlock(event) {
    event.preventDefault()
    const blockElement = event.target.closest('.block')
    const blockId = blockElement.dataset.blockId

    fetch(`/workspaces/${this.workspaceId}/pages/${this.pageId}/blocks/${blockId}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': this.getMetaValue('csrf-token'),
        'Accept': 'text/vnd.turbo-stream.html'
      }
    }).then((data) => data.text()).then((html) => Turbo.renderStreamMessage(html))
  }

  // Method to insert a new block from the slash command
  insertBlock(event) {
    event.preventDefault()
    const blockType = event.currentTarget.dataset.blockType

    fetchAndTurboRender(`/workspaces/${this.workspaceId}/pages/${this.pageId}/blocks`, {
      method: 'POST',
      body: {
        block_type: blockType,
        content: ''
      }
    }, () => {
      this.hideSlashMenu()
      const newEl = document.querySelector(`[data-block-type="${blockType}"] [contenteditable]`)
      newEl.focus()
    })
  }

  insertBlockKeys(event) {
    if (event.key === "Enter") {
      this.insertBlock(event)
    }
  }

  checkForSlash(event) {
    if (event.key === '/') {
      this.showSlashMenu()
    }
  }

  showSlashMenu() {
    this.slashMenuTarget.showPopover()
  }

  hideSlashMenu() {
    if (this.hasSlashMenuTarget) {
      this.slashMenuTarget.hidePopover()
    }
  }

  // Method to handle formatting shortcuts
  keyDown(event) {
    if ((event.ctrlKey || event.metaKey) && event.key === 'b') {
      event.preventDefault()
      document.execCommand('bold', false, null)
    }
    if ((event.ctrlKey || event.metaKey) && event.key === 'i') {
      event.preventDefault()
      document.execCommand('italic', false, null)
    }

    if (event.key === "Enter") {
      event.preventDefault()
      const blockElement = event.target.closest('.block')
      const blockType = blockElement.dataset.blockType
      const position = this.element.querySelectorAll('[id^="block_"].block').length

      if (blockType === 'text' || blockType.startsWith('heading')) {
        this.createBlockAtPosition('text', position, blockElement)
      } else if (blockType === 'bulleted_list' || blockType === 'numbered_list') {
        // Handled differently, see below
      }
    }

    if (event.key === 'Backspace') {
      const content = event.target.innerText.trim()
      if (content === '') {
        const blockElement = event.target.closest('.block')
        const blockId = blockElement.dataset.blockId
        this.deleteBlock(event)
      }
    }
  }

  updateListItem(event) {
    const blockElement = event.target.closest('[data-block-id]')
    const blockId = blockElement.dataset.blockId
    const items = Array.from(blockElement.querySelectorAll('li')).map(li => li.innerText.trim())

    // Update the block's data with the updated list items
    this.updateBlockData(blockId, { items: items })
  }

  handleListKeyDown(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
      const blockElement = event.target.closest('[data-block-id]')
      const blockId = blockElement.dataset.blockId
      const items = Array.from(blockElement.querySelectorAll('li')).map(li => li.innerText.trim())

      // Insert a new empty item after the current one
      const index = parseInt(event.target.dataset.index) + 1
      items.splice(index, 0, '')

      // Update the block's data
      this.updateBlockData(blockId, { items: items })
    } else if (event.key === 'Backspace') {
      const content = event.target.innerText.trim()
      if (content === '') {
        event.preventDefault()
        const blockElement = event.target.closest('[data-block-id]')
        const blockId = blockElement.dataset.blockId
        const index = parseInt(event.target.dataset.index)
        const items = Array.from(blockElement.querySelectorAll('li')).map(li => li.innerText.trim())

        // Remove the item from the list
        items.splice(index, 1)

        if (items.length === 0) {
          // Delete the block if no items are left
          this.deleteBlock(event)
        } else {
          // Update the block's data
          this.updateBlockData(blockId, { items: items })
        }
      }
    }
  }

  updateBlockData = debounce((blockId, data) => {
    // Send a PATCH request to update the block's data
    fetchAndTurboRender(`/workspaces/${this.workspaceId}/pages/${this.pageId}/blocks/${blockId}`, {
      method: 'PATCH',
      body: {
        block: {
          data: data
        }
      }
    })
  }, 200)

  createBlockAtPosition(blockType, position, fromBlock) {
    fetchAndTurboRender(`/workspaces/${this.workspaceId}/pages/${this.pageId}/blocks`, {
      method: 'POST',
      body: {
        block: {
          block_type: blockType,
          content: '',
          position,
        },
        insert_after: fromBlock.getAttribute("id")
      }
    }, () => {
      const blocks = document.querySelectorAll(`[data-block-type="${blockType}"] [contenteditable]`)
      blocks[position - 1].focus()
    })
  }

  updatePageTitle = debounce((event) => {
    if (event.key === "Enter") return;
    const title = event.target.innerText.trim()

    fetchAndTurboRender(`/workspaces/${this.workspaceId}/pages/${this.pageId}`, {
      method: 'PUT',
      body: {
        page: {
          title: title
        }
      }
    })
  }, 200)

  handleTitleKeyDown(event) {
    if (event.key === "Enter") {
      event.preventDefault()
      this.createAndFocusFirstBlock()
    }
  }

  createAndFocusFirstBlock() {
    fetchAndTurboRender(`/workspaces/${this.workspaceId}/pages/${this.pageId}/blocks`, {
      method: 'POST',
      body: {
        block_type: 'text',
        position: 1,
        content: ''
      }
    }, () => { document.querySelector("div.block p").focus() })
  }
}
