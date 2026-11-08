//click 
const click = document.getElementById('click');
const clickMessage = document.getElementById('clickMessage');

click.addEventListener('click', () => {
    clickMessage.textContent = "Success!!";
});

//mouseover and mouseout
const colorBox = document.getElementById('colorBox');

colorBox.addEventListener('mouseover', () => {
    colorBox.style.backgroundColor = '#e74c3c';
    colorBox.textContent = "mouseover";
});

colorBox.addEventListener('mouseout', () => {
    colorBox.style.backgroundColor = '#3498db';
    colorBox.textContent = "mouseout";
});


//submit event
const nameForm = document.getElementById('nameForm');
const userNameInput = document.getElementById('userName');
const formResult = document.getElementById('formResult');

nameForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = userNameInput.value;
    formResult.textContent = "Name: " + name;
});

const keyInput = document.getElementById('keyInput');
const keyPressedSpan = document.getElementById('keyPressed');

keyInput.addEventListener('keydown', (e) => {
    keyPressedSpan.textContent = e.key;
});