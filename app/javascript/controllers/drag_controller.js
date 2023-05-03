import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="drag"
export default class extends Controller {
  dragStart(event) {
    const targetToBeMoved = event.target;
    if (targetToBeMoved.innerText != '') {
      event.dataTransfer.setData('text/plain', event.target.id);
    }
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

    const currentID = currentSquare.id;
    const targetID = targetSquare.id;
    const gameID = targetID.split('-')[1];

    // Move the chess piece to the target square
    // if (
    //   targetSquare !== currentSquare &&
    //   targetSquare.innerText.split('_')[1] !==
    //     currentSquare.innerText.split('_')[1]
    // ) {
    //   currentSquare.classList = 'cell';
    //   targetSquare.classList = `cell ${currentSquare.innerText}`;
    //   targetSquare.innerText = currentSquare.innerText;
    //   currentSquare.id = `-${currentID.split('-')[1]}-${
    //     currentID.split('-')[2]
    //   }-${currentID.split('-')[3]}`;
    //   targetSquare.id = `${currentSquare.innerText}-${targetID.split('-')[1]}-${
    //     targetID.split('-')[2]
    //   }-${targetID.split('-')[3]}`;
    //   currentSquare.innerText = '';
    // }

    const piece = currentID.split('-')[0];
    const currentx = currentID.split('-')[2];
    const currenty = currentID.split('-')[3];
    const targetx = targetID.split('-')[2];
    const targety = targetID.split('-')[3];

    const csrfToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute('content');
    // Make an HTTP request to call the move method in the Rails controller
    fetch(`/games/${gameID}/move_piece`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      body: JSON.stringify({
        piece,
        currentx,
        currenty,
        targetx,
        targety,
      }),
    });
  }
}
