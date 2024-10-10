import { Controller } from "@hotwired/stimulus";

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
    position: parseInt(el.dataset.blockPosition, 10),
  };
}

export default class extends Controller {
  connect() {
    this.dragHandle = this.element.querySelector('.drag-handle');

    combine(
      draggable({
        element: this.dragHandle,
        getInitialData: () => {
          return getBlockData(this.element);
        },
        onGenerateDragPreview: ({ nativeSetDragImage }) => {
          setCustomNativeDragPreview({
            nativeSetDragImage,
            getOffset: pointerOutsideOfPreview({
              x: '16px',
              y: '8px',
            }),
            render: ({ container }) => {
              // Customize your drag preview here if needed
            },
          });
        },
        onDragStart: () => {
          this.setDraggingStatus();
        },
        onDrop: ({ location }) => {
          this.setIdleStatus();
        },
      }),
      dropTargetForElements({
        element: this.element,
        canDrop: ({ source }) => {
          if (source.element === this.element) return false;

          return !!source.data.position && !!source.data.id;
        },
        getData: ({ input, element }) => {
          const data = getBlockData(element);
          return attachClosestEdge(data, {
            input,
            element,
            allowedEdges: ['top', 'bottom'],
          });
        },
        getIsSticky: () => true,
        onDrag: ({ self }) => {
          const closestEdge = extractClosestEdge(self.data);
          this.highlightEdge(closestEdge);
        },
        onDragLeave: () => {
          this.removeHighlight();
          this.setIdleStatus();
        },
        onDrop: ({ source, self }) => {
          this.removeHighlight();
          this.setIdleStatus();

          const sourceElement = source.element.closest('[data-controller~="block"][data-controller~="sortable"]');
          const targetElement = self.element;
          const closestEdge = extractClosestEdge(self.data);

          if (sourceElement && targetElement) {
            if (closestEdge === 'top') {
              targetElement.parentNode.insertBefore(sourceElement, targetElement)
            } else if (closestEdge === 'bottom') {
              targetElement.parentNode.insertBefore(sourceElement, targetElement.nextSibling)
            }

            this.updatePositions();
          }
        },
      })
    );
  }

  setIdleStatus() {
    this.dragHandle.classList.add('cursor-grab');
    this.dragHandle.classList.remove('cursor-grabbing');
  }

  setDraggingStatus() {
    this.dragHandle.classList.remove('cursor-grab');
    this.dragHandle.classList.add('cursor-grabbing');
  }

  highlightEdge(edge) {
    const letter = edge.substring(0, 1);
    this.removeHighlight()
    this.element.classList.add(`border-${letter}-2`, 'border-indigo-200', 'border-solid');
  }

  removeHighlight() {
    this.element.classList.remove('border-t-2', 'border-b-2', 'border-indigo-200', 'border-solid');
  }

  updatePositions() {
    const blocksContainer = document.getElementById('blocks');
    const blockElements = blocksContainer.querySelectorAll('[data-controller~="block"][data-controller~="sortable"]');

    const workspaceId = blocksContainer.dataset.blocksWorkspaceId;
    const pageId = blocksContainer.dataset.blocksPageId;

    const blocksData = [];

    blockElements.forEach((blockElement, index) => {
      const blockId = blockElement.dataset.blockId;
      const newPosition = index + 1;

      blockElement.dataset.blockPosition = newPosition;

      blocksData.push({ id: blockId, position: newPosition });
    });

    const url = `/workspaces/${workspaceId}/pages/${pageId}/blocks/batch_update_positions`;

    fetch(url, { 
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ blocks: blocksData })
    })
      .then((response) => {
        if (!response.ok) {
          return response.json().then((data) => {
            console.error('Failed to batch update blocks:', data.error);
          });
        }
      })
      .catch((error) => {
        console.error('Error batch updating blocks:', error);
      });
  }
}
