let sortingStates = [];

function getUserData(column, order) {
    let Http = new XMLHttpRequest();
    const url = "/admin/userData?column=" + column + "&" + "order=" + order;

    Http.open("GET", url);
    Http.send();

    Http.onreadystatechange = function() {
        if ( this.readyState == 4 && this.status == 200 ) {
            updateUserTable(JSON.parse(Http.responseText));
        }
    }
}

function updateUserTable(userData) {
    // Clear userTable
    let userTable = document.getElementById("userTable");
    let cNode = userTable.cloneNode(false);
    userTable.parentNode.replaceChild(cNode, userTable);

    userTable = document.getElementById("userTable");
    cNode = userTable.cloneNode(false);

    
    for ( let row of userData ) {
      let tempP = document.createElement("p");
      tempP.classList.add("firstName");
      let tempNode = document.createTextNode(row.first_name);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("lastName");
      tempNode = document.createTextNode(row.last_name);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("class");
      tempNode = document.createTextNode(row.class);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("email");
      tempNode = document.createTextNode(row.email);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("code");
      tempNode = document.createTextNode(row.code);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("score");
      tempNode = document.createTextNode(row.score);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("alive");
      tempNode = document.createTextNode(row.alive);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);

      tempP = document.createElement("p");
      tempP.classList.add("target");
      tempNode = document.createTextNode(row.target_name);
      tempP.appendChild(tempNode);
      cNode.appendChild(tempP);
    }

    userTable.parentNode.replaceChild(cNode, userTable);
}

function setupOnClicks() {
    let tableHeaders = document.getElementsByClassName("tableHead");

    for ( let i = 0; i < tableHeaders.length; i++ ) {
        let head = tableHeaders[i];
        sortingStates.push(null);
        head.addEventListener("click", function() {tableHeaderOnClick(i, head.classList[1])});
    }
}

function tableHeaderOnClick(index, className) {
    let classNames = new Map([
        ["firstName", "first_name"],
        ["lastName", "last_name"],
        ["class", "class"],
        ["email", "email"],
        ["code", "code"],
        ["score", "score"],
        ["alive", "alive"],
        ["target", "target"],
    ]);

    let orderStates = new Map([
        [true, "asc"],
        [false, "desc"],
    ]);

    for ( let i = 0; i < sortingStates.length; i++ ) {
        if ( i == index ) {
            sortingStates[i] = !sortingStates[i];
        } else {
            sortingStates[i] = null;
        }
    }

    let tableHeaders = document.getElementsByClassName("tableHead");

    for ( let i = 0; i < tableHeaders.length; i++ ) {
        if ( i == index ) {
            tableHeaders[i].classList.add("headerBold");
        } else {
            tableHeaders[i].classList.remove("headerBold");
        }
    }
    
    getUserData(classNames.get(className), orderStates.get(sortingStates[index]))
}

setupOnClicks();
getUserData("class", "asc");
