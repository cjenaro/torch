import { Controller } from "@hotwired/stimulus"

import {
  draggable,
  dropTargetForElements,
} from '@atlaskit/pragmatic-drag-and-drop/element/adapter';
import { setCustomNativeDragPreview } from '@atlaskit/pragmatic-drag-and-drop/element/set-custom-native-drag-preview';
import { pointerOutsideOfPreview } from '@atlaskit/pragmatic-drag-and-drop/element/pointer-outside-of-preview';
import { combine } from '@atlaskit/pragmatic-drag-and-drop/combine';
import {
  attachClosestEdge,
  extractClosestEdge,
} from '@atlaskit/pragmatic-drag-and-drop-hitbox/closest-edge';

function getBlockData(el) {
  return {
    id: el.dataset.blockId,
    position: el.dataset.blockPosition
  }
}

export default class extends Controller {
  connect() {
    combine(
      draggable({
        element: this.element,
        getInitialData() {
          return getBlockData(this.element)
        },
        onGenerateDragPreview({ nativeSetDragImage }) {
          setCustomNativeDragPreview({
            nativeSetDragImage,
            getOffset: pointerOutsideOfPreview({
              x: '16px',
              y: '8px',
            }),
            render({ container }) {
              // setState({ type: 'preview', container });
              // STATUS === preview, el container
            },
          });
        },
        onDragStart() {
          //setState({ type: 'is-dragging' });
          // STATUS === dragging
        },        
        onDrop() {
          console.log("DROPPED ELEMENT")
        }
      }),
      dropTargetForElements({
        element: this.element,
        canDrop({ source }) {
          if (source.element === this.element) return false;

          return !!source.data.position && !!source.data.id
        }
      }),
      getData({ input, element }) {
        const data = getBlockData(element) 
        return attachClosestEdge(data, {
          input,
          element,
          allowedEdges: ['top', 'bottom']
        })
      },
      getIsSticky() {
        return true
      },
      onDragEnter({ self }) {
        const closestEdge = extractClosestEdge(self.data);
        console.log("Dragging over", closestEdge)
      },
      onDrag({ self }) {
        const closestEdge = extractClosestEdge(self.data);

        // if STATUS.type !== dragging-over && STATUS.currentEdge !== closestEdge
        // UPDATE STATUS
      },
      onDragLeave() {
        // STATUS to idle
      },
      onDrop() {
        // STATUS to idle
      }
    )
  }

  /**
  This is thefinal call to update the block position
  end(event) {
    let id = event.item.dataset.blockId
    let data = new FormData()
    data.append("position", event.newIndex + 1)

    fetch(event.item.dataset.updateUrl, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: data
    })
  }
   */
}
