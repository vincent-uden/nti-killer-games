// True if animation playing
let buttonStates = [];

function initButtons() {
    let buttons = document.getElementsByClassName("squish");
    for ( let i = 0; i < buttons.length; i++ ) {
        buttonStates.push(false);
        buttons[i].id = "button" + i;
        buttons[i].addEventListener("click", function() {
            buttonOnClick(i);
        });
    }
}

function buttonOnClick(index) {
    if ( !buttonStates[index] ) {
        buttonStates[index] = true;
        let button = document.getElementById("button" + index);
        button.classList.add("active");

        setTimeout(function() {
            let finishedButton = document.getElementById("button" + index);
            finishedButton.classList.remove("active");
            buttonStates[index] = false;
        }, 200);
    } 
}

initButtons();
