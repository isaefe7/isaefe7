const home = document.getElementById("home");

home.addEventListener("click", (e) => {
  console.log("home");
  alert("You are already on home page");
  e.preventDefault();
});

const about = document.getElementById("about");
about.addEventListener("click", (e) => {
  console.log("about");
  //  window.open("about.html"); //to open the page in another tab
  window.location.href = "about.html"; //to open the page in the same tab
  e.preventDefault();
});

const education = document.getElementById("education");
education.addEventListener("click", (e) => {
  console.log("education");
  window.location.href = "education.html"; //to open the page in the same tab
  e.preventDefault();
});

const future = document.getElementById("future");
future.addEventListener("click", (e) => {
  console.log("future career");
  window.location.href = "future.html"; //to open the page in the same tab
  e.preventDefault();
});

const changecolor = document.querySelector(".changecolor");
changecolor.addEventListener("mouseover", (e) => {
  document.body.style.backgroundColor = "lightblue";
});

changecolor.addEventListener("mouseout", (e) => {
  document.body.style.backgroundColor = "azure";
});

const submit = document.querySelector(".submit");
const message = document.querySelector("#message");
const output = document.querySelector("#output");

submit.addEventListener("submit", (e) => {
  e.preventDefault();
  output.textContent = message.value;
  message.value = "";
});

console.log("events.js loaded");
