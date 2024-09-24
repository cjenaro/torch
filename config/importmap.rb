# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@atlaskit/pragmatic-drag-and-drop", to: "@atlaskit--pragmatic-drag-and-drop.js" # @1.3.1
pin "@atlaskit/pragmatic-drag-and-drop-flourish", to: "@atlaskit--pragmatic-drag-and-drop-flourish.js" # @1.1.1
pin "@atlaskit/pragmatic-drag-and-drop-hitbox", to: "@atlaskit--pragmatic-drag-and-drop-hitbox.js" # @1.0.3
