/* const ptitle = document.getElementById("title");
console.log(ptitle);

const football = document.getElementById("Football");
console.log(football);

const Armwrestling = document.getElementById("Armwrestling");
console.log(Armwrestling);

const tennis = document.getElementById("Tennis");
console.log(tennis);

const Swimming = document.getElementById("Swimming");
console.log(Swimming);

const mainheader = document.getElementsByClassName("main-container");
console.log(mainheader);

const football2 = document.querySelector("#football");
console.log(football2);

const divs = document.querySelectorAll("div");
console.log(divs);

const ul = document.getElementsByTagName("ul");
console.log(ul);

const li = document.getElementsByTagName("li");
console.log(li);
*/

// CREATE A NEW ELEMENT
// const ul = document.querySelector("ul");
console.log(ul);

const li = document.createElement("li");
ul.append(li);
li.innerText = "Running";

const football = document.querySelector("#Football");
console.log(football);
football.style.color = "red";

const tennis = document.querySelector("#Tennis");
console.log(tennis);
tennis.style.color = "lightblue";

/* 
const div = document.querySelector(".main-container");
console.log(div);
div.style.fontFamily = "Arial, sans-serif";
div.style.fontSize = "24px";
div.style.backgroundColor = "lightgreen";
*/

const listitems = document.querySelectorAll(".list");
console.log(listitems);

for (let i = 0; i < listitems.length; i++) {
  listitems[i].style.color = "blue";
  listitems[i].style.fontSize = "20px";
}

const paragraph = document.getElementById("title");
console.log(paragraph.innerText);

const handball = document.querySelector(".handball");
console.log(handball.textContainer);

// PARENT NODE TREVERSAL
const ul = document.querySelector("ul");
// console.log(ul);
console.log(ul.parentNode);
console.log(ul.parentElement);
console.log(ul.parentNode.parentNode);

// CHILD NODE TREVERSAL
console.log(ul.childNodes);
console.log(ul.children);
console.log(ul.children[2]);
console.log(ul.firstChild); //text
console.log(ul.firstElementChild); //Football
console.log(ul.lastChild); //text
console.log(ul.lastElementChild); //swimming

ul.children[3].style.color = "green";
ul.firstElementChild.style.color = "purple";

// SIBLING NODE TREVERSAL
console.log(body.previousSibling); //text
console.log(body.previousElementSibling); //head
console.log(ul.nextSibling); //text
console.log(ul.nextElementSibling); //null
