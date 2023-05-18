window.addEventListener('click', (event) => {
  if (event.target.classList.contains('promotion-selected')) {
    const piece = event.target.id.split('-')[0];
    const gameID = event.target.id.split('-')[1];
    const currenty = event.target.id.split('-')[2];
    const currentx = event.target.id.split('-')[3];

    const csrfToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute('content');
    // Make an HTTP request to call the move method in the Rails controller
    fetch(`/games/${gameID}/promotion`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      body: JSON.stringify({
        piece,
        currentx,
        currenty,
      }),
    });
  }
});
