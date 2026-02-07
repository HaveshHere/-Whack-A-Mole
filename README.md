# 🐻 Whack-A-Mole
An interactive arcade-style game implemented using Verilog HDL on the Intel Cyclone V FPGA. This project was developed during the VeCAD Elite Voluntary Internship 2025 at Universiti Teknologi Malaysia.

## 🛠️ Features
Here's what you can do with this FPGA-based game:
- Whack Moles: React to random LED appearnces LEDR (0-3) and hit them using corresponding push buttons KEY (0-3).
  
- Audio Feedback: Hear distinct tones for correct hits and penalties via the passive buzzer.
  
- Dynamic Difficulty: Experience faster mole switching as your score increases.
  
- Smart States: Monitor system status via "ST" (Start/Idle) and "FI" (Finish/Game Over) messages.

## 🕹️ How to Play 
- Start Game: Press any button KEY (0-3) while the 7-segment display shows "ST" (Idle state) to initialize the timers and score.
  
- Whack a Mole: Watch the LEDs LEDR (0-3); when a mole appears, quickly press the corresponding KEY (0-3) to score.
  
- Scoring: Correct hits increment your score on the HEX (0-1) displays, while incorrect presses will result in a penalty of deducting one points from your current score.
  
- Feedback: Listen for the Buzzer, it will emit distinct tones for correct hits versus wrong hits.
  
- Game Over: Once the 60-second timer hits zero, the dislay will show "FI" (Finish) and your final score.
  
- Restart: While in the "FI" state, press any button to return the system to the "ST" idle state and play again.
  
- Emergency Reset: Double-tap KEY3 at any time to trigger the custom reset module and restart the system logic.

## 💭 How can it be improved?
- Use the VGA port to show the game on a computer screen instead of just using LEDs.
  
- Upgrade the buzzer to a real audio system for higher-quality sound effects.
  
- Use the on-board memory or the ARM processor to save and show the highest scores.
  
- Add selectable game modes with different speeds and timers.
  
- Let two people play at the same time to make it competitive.

## 🎥 Video

[https://drive.google.com/file/d/18xgqKBGixJvI2DoXaJb7VtH317SaS0FA/view?usp=sharing]
