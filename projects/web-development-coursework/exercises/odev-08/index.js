const h1 = document.getElementById("title");
console.log(h1);

const divs = document.querySelectorAll("div");
console.log(divs);

const listitems = document.querySelectorAll("li");
console.log(listitems);

for (let i = 0; i < listitems.length; i++) {
  const listitem = listitems[i];
  console.log(listitem);
}

for (let i = 0; i < listitems.length; i++) {
  listitems[i].style.color = "blue";
  listitems[i].style.fontSize = "24px";
  listitems[i].style.fontFamily = "Arial, sans-serif";
  listitems[i].style.fontWeight = "bold";
  listitems[i].style.border = "2px solid black";
  listitems[i].style.padding = "10px";
  listitems[i].style.margin = "5px";
}

const maincontainer = document.getElementsByClassName("main-container");
console.log(maincontainer);

const ul = document.querySelector("ul");
console.log(ul);

const li = document.querySelector("li");
ul.append(li);
console.log(li);
li.innerText = "olecranon";

/*
const olecranon = document.querySelector("#olecranon ulna bone");
console.log(olecranon);
olecranon.style.color = "red";

button.style.backgroundColor = "orange";
button.style.color = "purple";
button.style.fontSize = "20px";
button.style.padding = "10px 20px";
button.style.border = "none";
button.style.borderRadius = "5px";
button.style.cursor = "pointer";

ul.children[3].style.fontSize = "4px";
ul.firstElementChild.style.color = "purple";
*/
