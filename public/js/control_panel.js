let stateMsgs = [
      "NTI Killer Games har inte startat än",
      "NTI Killer Games är igång",
      "NTI Killer Games är över"
];


function setGameState(index) {
    let http = new XMLHttpRequest();
    const url = "/superuser/setGameState?state=" + index;

    http.open("POSt", url);

    http.onreadystatechange = function() {
        if ( this.readyState == 4 && this.status == 200 ) {
            console.log(this.responseText);
            updateStateButtons(index);
        }
    }

    http.send();
}

function updateStateButtons(index) {
    let buttons = document.getElementsByClassName("stateButton");
    for ( let button of buttons ) {
        button.classList.remove("disabled");
        button.disabled = false;
    }
    buttons[index].classList.add("disabled");
    buttons[index].disabled = "true";

    let title =  document.getElementById("stateTitle");
    title.innerText = stateMsgs[index];
}

