// DOM refs
const addTipBtn = document.getElementById("addTipBtn");
const newTipInput = document.getElementById("newTip");
const tipsList = document.getElementById("tipsList");

const addPlayerBtn = document.getElementById("addPlayerBtn");
const playerNameInput = document.getElementById("playerName");
const playersList = document.getElementById("players");

const calcBtn = document.getElementById("calcBtn");
const weightInput = document.getElementById("weight");
const hoursInput = document.getElementById("hours");
const calcResult = document.getElementById("calcResult");

// add training tip
addTipBtn.addEventListener("click", () => {
  const text = newTipInput.value.trim();
  if (!text) return;
  const li = document.createElement("li");
  li.textContent = text;
  tipsList.append(li);
  newTipInput.value = "";
});

// add player
addPlayerBtn.addEventListener("click", () => {
  const name = playerNameInput.value.trim();
  if (!name) return;
  const li = document.createElement("li");
  li.textContent = name;
  playersList.append(li);
  playerNameInput.value = "";
});

// simple calculator with logic
calcBtn.addEventListener("click", () => {
  const w = parseFloat(weightInput.value);
  const h = parseFloat(hoursInput.value);
  if (isNaN(w) || isNaN(h)) {
    calcResult.textContent = "Lütfen sayı girin.";
    return;
  }
  const score = w * 0.4 + h * 5;
  let level;
  if (score >= 120) level = "İleri";
  else if (score >= 80) level = "Orta";
  else level = "Başlangıç";
  calcResult.textContent = `Puan: ${Math.round(score)} — Seviye: ${level}`;
});
