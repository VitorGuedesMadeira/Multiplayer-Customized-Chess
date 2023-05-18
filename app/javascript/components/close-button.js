window.addEventListener("click", (event) => {
    if(event.target.classList == "close-button button2") {
        event.target.parentElement.classList.add("hide")
    }
})
