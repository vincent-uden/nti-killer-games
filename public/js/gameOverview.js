let interval = setInterval(function() {
    if (window.textFit) {
        clearInterval(interval);
        textFit(document.getElementById("ntih1"), {widthOnly: true, maxFontSize: 800});
        textFit(document.getElementById("killerh1"), {widthOnly: true, maxFontSize: 800, detectMultiLine: false});
    }
}, 50);

function confirmDeath() {
    let popupDiv = document.getElementById("confirmDeathWrapper");
    popupDiv.classList.add("poppedUp");
    let container = document.getElementById("container");
    container.classList.add("blurred");
}

function cancelPopup() {
    let popupDiv = document.getElementById("confirmDeathWrapper");
    popupDiv.classList.remove("poppedUp");
    let container = document.getElementById("container");
    container.classList.remove("blurred");
}

