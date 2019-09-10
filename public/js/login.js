let interval = setInterval(function() {
    if (window.textFit) {
        if (window.innerWidth > 500) {
            clearInterval(interval);
            textFit(document.getElementById("ntih1"), {widthOnly: true, maxFontSize: 200});
            textFit(document.getElementById("killerh1"), {widthOnly: true, maxFontSize: 200, detectMultiLine: false});
        } else {
            clearInterval(interval);
            textFit(document.getElementById("ntih1"), {widthOnly: true, maxFontSize: 800});
            textFit(document.getElementById("killerh1"), {widthOnly: true, maxFontSize: 800, detectMultiLine: false});
        }
    }
}, 50);


