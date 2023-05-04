import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="drag"
export default class extends Controller {
  dragStart(event) {
    const targetToBeMoved = event.target;
    if (targetToBeMoved.innerText != '') {
      event.dataTransfer.setData('text/plain', event.target.id);

      const gameID = event.target.id.split('-')[1];
      const piece = event.target.id.split('-')[0];
      const currentx = event.target.id.split('-')[2];
      const currenty = event.target.id.split('-')[3];

      const csrfToken = document
        .querySelector("meta[name='csrf-token']")
        .getAttribute('content');
      // Make an HTTP request to call the move method in the Rails controller
      fetch(`/games/${gameID}/check_positions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
        },
        body: JSON.stringify({
          piece,
          currentx,
          currenty,
        }),
      })
        .then((response) => response.json()) // Extract JSON data from response
        .then((data) => {
          for (let i = 0; i < data.length; i++) {
            let cell = document.querySelector(
              `.board .row:nth-child(${data[i][1] + 1}) .cell:nth-child(${
                data[i][0] + 1
              })`
            );
            cell.classList.add('highlight');
          }
        });
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
    event.target.classList.remove('highlight');
    // Get the ID of the drag and drop positions (start and finish)
    const currentID = event.dataTransfer.getData('text/plain');
    const targetID = event.target.id;

    const gameID = currentID.split('-')[1];
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
