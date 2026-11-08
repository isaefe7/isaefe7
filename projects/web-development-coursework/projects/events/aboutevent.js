document.addEventListener("keydown", (e) => {
  console.log(e.key);
  if (e.key === "g") {
    alert("GAME BEGINS");
  } else if (e.key === "Escape") {
    window.location.href = "index.html";
  } else {
    alert("press g to game begin");
    console.log(e.target); //body
    console.log(e.type); //keydown
  }
});

/*
window.addEventListener("keydown", (e) => {
  if (e.ctrlKey && e.key === "s") {
    e.preventDefault(); // stop browser save
    console.log("Ctrl + S pressed");
  }
});
*/
