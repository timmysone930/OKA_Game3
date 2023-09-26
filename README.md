# loading bar style

```css
body {
  touch-action: none;
  margin: 0;
  border: 0 none;
  padding: 0;
  text-align: center;
  background-color: black;
  height: 100vh;
  width: 100vw;
  background-image: url("./images/splash.png");
  background-repeat: no-repeat;
  background-size: contain;
  background-position: center;
}

#status-progress {
  width: calc(min(60vh, 60vw) - 20px);
  height: calc(min(5vh, 5vw));
  background-color: #823419;
  border: 5px solid #fff;
  box-shadow: 0px 4px 0px 0px rgba(0, 0, 0, 0.2);
  border-radius: 2px;
  visibility: visible;
  border-radius: 50px;
  position: relative;
}

#loadingText {
  content: url("./images/loading_text.png");
  width: calc(min(29.3vh, 29.3vw));
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -120%);
}

#status-progress-innerBorder {
  height: 100%;
  box-sizing: border-box;
  border: 5px solid #ffb833;
  border-radius: 50px;
}

#status-progress-inner {
  height: 100%;
  width: 0;
  box-sizing: border-box;
  transition: width 0.5s linear;
  background-color: #a5d313;
  border-radius: 50px;
  box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.2);
}
```

```html
<div
  id="status-progress"
  style="display: none;"
  oncontextmenu="event.preventDefault();"
>
  <img id="loadingText" />
  <div id="status-progress-innerBorder">
    <div id="status-progress-inner"></div>
  </div>
</div>
```

```js
// setStatusMode('indeterminate');
engine
  .startGame({
    onProgress: function (current, total) {
      if (total > 0) {
        statusProgressInner.style.width = (current / total) * 100 + "%"
        setStatusMode("progress")
        // if (current === total) {
        // 	// wait for progress bar animation
        // 	setTimeout(() => {
        // 		setStatusMode('indeterminate');
        // 	}, 500);
        // }
      } else {
        setStatusMode("indeterminate")
      }
    },
  })
  .then(() => {
    setStatusMode("hidden")
    initializing = false
  }, displayFailureNotice)
```

Maybe you can directly replace the index.html