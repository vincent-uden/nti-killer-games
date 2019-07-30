function getUserData() {
    let Http = new XMLHttpRequest();
    const url = "/admin/userData?column=first_name&order=desc";

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

    
    for (let row of userData) {
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

getUserData();
