# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@atlaskit/pragmatic-drag-and-drop/element/adapter", to: "@atlaskit--pragmatic-drag-and-drop--element--adapter.js" # @1.3.1
pin "@babel/runtime/helpers/defineProperty", to: "@babel--runtime--helpers--defineProperty.js" # @7.25.6
pin "@babel/runtime/helpers/slicedToArray", to: "@babel--runtime--helpers--slicedToArray.js" # @7.25.6
pin "@babel/runtime/helpers/toConsumableArray", to: "@babel--runtime--helpers--toConsumableArray.js" # @7.25.6
pin "bind-event-listener" # @3.0.0
pin "raf-schd" # @4.0.3
pin "@atlaskit/pragmatic-drag-and-drop/element/set-custom-native-drag-preview", to: "@atlaskit--pragmatic-drag-and-drop--element--set-custom-native-drag-preview.js" # @1.3.1
pin "@atlaskit/pragmatic-drag-and-drop/element/pointer-outside-of-preview", to: "@atlaskit--pragmatic-drag-and-drop--element--pointer-outside-of-preview.js" # @1.3.1
pin "@atlaskit/pragmatic-drag-and-drop/combine", to: "@atlaskit--pragmatic-drag-and-drop--combine.js" # @1.3.1
pin "@atlaskit/pragmatic-drag-and-drop-hitbox/closest-edge", to: "@atlaskit--pragmatic-drag-and-drop-hitbox--closest-edge.js" # @1.0.3
