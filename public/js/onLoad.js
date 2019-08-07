setTimeout(function () {
        let viewheight = window.visualViewport.height;
        let viewwidth = window.visualViewport.width;
        let viewport = document.querySelector("meta[name=viewport]");
        viewport.setAttribute("content", "height=" + viewheight + "px, width=" + viewwidth + "px, initial-scale=1.0");
    }, 300);
