let genBttn = document.getElementById("codeGenButton");
genBttn.addEventListener("click", getNewCode);

function getNewCode() {
    let Http = new XMLHttpRequest();
    const url = "/admin/genNewCode";

    Http.open("GET", url);

    Http.onreadystatechange = function() {
        if ( this.readyState == 4 && this.status == 200 ) {
            updateCurrentCode(Http.responseText);
        }
    }

    Http.send();
}

function updateCurrentCode(newCode) {
    let elem = document.getElementById("code-container");
    elem.innerText = newCode;
}

