const buton = document.getElementById("hesaplaBtn");
const inputAlanı = document.getElementById("notInput");

buton.addEventListener("click", function () {
  // Kutudaki değeri al ve büyük harfe çevir
  let not = inputAlanı.value.toUpperCase();

  console.log("Girilen Not: " + not);

  if (not == "A" || not == "B") {
    console.log("Tebrikler, geçtiniz!");
  } else if (not == "C" || not == "D") {
    console.log("Geçtiniz.");
  } else if (not == "F") {
    console.log("Kaldınız.");
  } else {
    console.log("Geçersiz bir harf girdiniz.");
  }
});

let not = prompt("Lütfen harf notunuzu giriniz (A, B, C, D, F):").toUpperCase();
let mesaj = "";
switch (not) {
  case "A":
    mesaj = "Harika iş!";
    break;
  case "B":
    mesaj = "Çok güzel.";
    break;
  case "C":
    mesaj = "İdare eder.";
    break;
  case "D":
    mesaj = "Ucu ucuna.";
    break;
  case "F":
    mesaj = "Daha çok çalışmalısın.";
    break;
  default:
    mesaj = "Geçersiz bir harf girdiniz.";
}
let sayisalNot = 0;
if (not == "A") sayisalNot = 100;
else if (not == "B") sayisalNot = 80;
else if (not == "C") sayisalNot = 70;
else if (not == "D") sayisalNot = 50;
else sayisalNot = 0;

let sonucMesaji = "Harf notun: " + not + ", Puanın: " + sayisalNot;
