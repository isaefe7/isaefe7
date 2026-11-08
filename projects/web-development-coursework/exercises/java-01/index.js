// java codes

console.log("Hello World");
let ist = 10;
console.log(typeof ist);
num = 5;
console.log(num);

// veriable names shouldnt start with a number
// numbers, strings, boolens, underfined. NaN

let anum = 5; // number
let a = false; // boolean
let name = "Jesus"; // string
let arr = [1, 2, 3]; // array
let obj = { name: "Jesus", age: 34 }; // object
let un; // undefined

//ARITMETIC OPERATORS
let x = 5;
let y = 10;
let total1 = x + y;
let diff = y - x;
let mult = x * y;
let div = y / x;
let mod = y % x;
console.log("Total: " + total1);
console.log("Difference: " + diff);
console.log("Multiplication: " + mult);
console.log("Division: " + div);
console.log("Modulus: " + mod);

// COMPARISON OPERATORS
console.log(x == y); // false
console.log(x != y); // true
console.log(x > y); // false
console.log(x < y); // true
console.log(x >= y); // false
console.log(x <= y); // true

// LOGICAL OPERATORS
console.log(x < y && x == 5); // true
console.log(x < y || x == 10); // true
console.log(!(x < y)); // false

// SPECIALS
// let.triangle = (side1: 10, side2: 0, side3: 5);
side1 in triangle; // true

// CONDITIONAL STATEMENTS
let num = prompt("Enter a number: ");
if (num == 5) {
  console.log("The number is 5");
} else if (num > 5) {
  console.log("The number is greater than 5");
} else {
  console.log("The number is less than 5");
}

if (num % 2 == 0) {
  console.log("The number is even");
} else {
  console.log("The number is odd");
}

let num1 = prompt("Enter first number: ");
let digit = num1.length;
console.log(digit);

switch (digit) {
  case 1:
    console.log("The number is single digit is one");
  case 2:
    console.log("The number is two digit");
  case 3:
    console.log("The number is three digit");
  default:
    console.log("The number is more than three digit");
    break;
}

// LOOPS
let total = 0;
for (let num = 1; num <= 10; num++) {
  total += num;
}
console.log("Total: " + total);
