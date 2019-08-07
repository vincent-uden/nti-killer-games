let interval = setInterval(function() {
    if (window.textFit) {
        clearInterval(interval);
        textFit(document.getElementById("ntih1"), {widthOnly: true, maxFontSize: 800});
        textFit(document.getElementById("killerh1"), {widthOnly: true, maxFontSize: 800, detectMultiLine: false});
    }
}, 50);


