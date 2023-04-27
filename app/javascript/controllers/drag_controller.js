import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="drag"
export default class extends Controller {
  dragStart(event) {
    event.dataTransfer.setData('text/plain', event.target.id);
  }

  dragOver(event) {
    event.preventDefault();
    return true;
  }

  dragEnter(event) {
    event.preventDefault();
    event.target.classList.add('over');
  }

  dragLeave(event) {
    event.preventDefault();
    event.target.classList.remove('over');
  }

  dragEnd(event) {
    event.preventDefault();
  }

  dragDrop(event) {
    event.target.classList.remove('over');
    // Get the ID of the chess piece being dragged
    const pieceId = event.dataTransfer.getData('text/plain');

    // Get the current and target squares for the chess piece
    const currentSquare = document.getElementById(pieceId);
    const targetSquare = event.target;

    // Move the chess piece to the target square
    targetSquare.innerText = currentSquare.innerText;
    currentSquare.innerText = '';
  }
}
