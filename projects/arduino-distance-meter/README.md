# Arduino Distance Meter

An Arduino UNO circuit that measures distance with an **HC-SR04 ultrasonic sensor** and shows it on a **16x2 LCD**. Built and simulated in [Tinkercad Circuits](https://www.tinkercad.com/circuits).

## Problem
Show a live distance reading without a computer: trigger the sensor, time the echo, convert to centimetres and display it.

## Hardware
| Part | Role |
|---|---|
| Arduino UNO | Controller |
| HC-SR04 | Ultrasonic distance sensor (TRIG pin 9, ECHO pin 10) |
| 16x2 LCD (HD44780) | Display, 4-bit mode (RS 12, E 11, D4 5, D5 4, D6 3, D7 2) |
| 10 kΩ potentiometer | LCD contrast |
| Resistor | LCD backlight |

There is no buzzer in this circuit.

## How it works
1. A 10 µs pulse on TRIG makes the sensor send an ultrasonic burst.
2. `pulseIn` measures how long ECHO stays high (microseconds).
3. Distance = time × 0.0343 cm/µs ÷ 2 (the sound travels there and back).
4. A 30 ms timeout makes the display say "Menzil disi" (out of range) instead of freezing.

## Run it
1. Open Tinkercad Circuits and build the circuit above (or open your saved one).
2. Open **Code → Text** and paste [`src/distance_meter.ino`](src/distance_meter.ino).
3. Start the simulation and move the sensor's target.

On real hardware, upload the same sketch with the Arduino IDE.

## What I learned
- Timing hardware signals with `pulseIn` and converting time to distance with the speed of sound.
- Driving an LCD in 4-bit mode with `LiquidCrystal`.
- Handling a missing echo (timeout) so the program stays responsive.

## License
[MIT](LICENSE) © 2026 İsa Efe
