document.getElementById("services").addEventListener("click", function () {
  window.location.href = "services.html";
});

document.getElementById("bookyourspot").addEventListener("click", function () {
  window.location.href = "booknow.html";
});

const submit = document.querySelector(".submit");

submit.addEventListener("submit", function (e) {
  e.preventDefault();

  const name = document.getElementById("name").value;
  const phone = document.getElementById("phone").value;
  const email = document.getElementById("email").value;
  const message = document.getElementById("message").value;

  const paragraphs = document.querySelectorAll(".part2 section p");

  if ((paragraphs.length = 4)) {
    paragraphs[0].textContent = message;
    paragraphs[1].textContent = name;
    paragraphs[2].textContent = "Phone: " + phone;
    paragraphs[3].textContent = "Email: " + email;
  }
  submit.reset();
});
