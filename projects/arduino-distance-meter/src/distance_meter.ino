// Arduino UNO distance meter: HC-SR04 ultrasonic sensor + 16x2 LCD (4-bit mode).
// Written for Tinkercad Circuits. Check the pin numbers against your own circuit.
#include <LiquidCrystal.h>

const int tetikPin = 9;    // HC-SR04 TRIG
const int yankiPin = 10;   // HC-SR04 ECHO

// LCD: RS, E, D4, D5, D6, D7
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

long sureOlc() {
  digitalWrite(tetikPin, LOW);
  delayMicroseconds(2);
  digitalWrite(tetikPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(tetikPin, LOW);
  return pulseIn(yankiPin, HIGH, 30000UL);   // timeout: about 5 m
}

void setup() {
  pinMode(tetikPin, OUTPUT);
  pinMode(yankiPin, INPUT);
  lcd.begin(16, 2);
  lcd.print("Mesafe Olcer");
  delay(1000);
  lcd.clear();
}

void loop() {
  long sure = sureOlc();                      // microseconds
  lcd.setCursor(0, 0);
  lcd.print("Mesafe:         ");
  lcd.setCursor(0, 1);
  if (sure == 0) {
    lcd.print("Menzil disi     ");
  } else {
    float mesafeCm = sure * 0.0343 / 2.0;     // speed of sound 343 m/s, round trip
    lcd.print(mesafeCm, 1);
    lcd.print(" cm        ");
  }
  delay(250);
}
