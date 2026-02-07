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

## 📅 The Process

I began by learning how Verilog works in Intel Quartus through YouTube tutorials and online research to understand the functions of each part of the code. I also familiarized myself with the DE1-SOC board, which I borrowed during my internship. Most of my time was spent experimenting with the board, testing key components such as LEDs and buttons, and observing how inputs affected outputs like the 7-segment display.

Throughout the process, I encountered various errors, which I addressed using AI tools like ChatGPT, Stack Overflow, and Gemini. I also collaborated with my colleagues and supervisors to break down problems and find solutions. Gradually, I learned to combine all the tested functions into a mini-game, like Whack-a-Mole. In the end, everything worked well, and I gained a lot of hands-on experience and practical understanding.

## 📈 Overall Growth

Throughout this project, I developed stronger problem-solving and debugging skills, learning to approach challenges methodically and use available resources effectively. My technical confidence with Verilog and the DE1-SOC board improved significantly, and I gained experience integrating multiple functions into a cohesive project. Working closely with colleagues and supervisors also enhanced my collaboration and communication skills. Overall, this experience taught me persistence, adaptability, and how to turn trial-and-error into meaningful learning.

## 💭 How can it be improved?
- Use the VGA port to show the game on a computer screen instead of just using LEDs.
  
- Upgrade the buzzer to a real audio system for higher-quality sound effects.
  
- Use the on-board memory or the ARM processor to save and show the highest scores.
  
- Add selectable game modes with different speeds and timers.
  
- Let two people play at the same time to make it competitive.

## 🚦Running the Project
1. Clone this repository to your local machine.
  
2. Install Intel Quartus Prime (ensure the required version is supported).

3. Select the correct FPGA device based on the board you are using.
   - For this project, the DE1-SoC board is used.
   - Target device: Cyclone V – 5CSEMA5F31C6N.

4. Open the project in Quartus Prime and compile the design.
   
5. Connect the DE1-SoC board to your computer and program the FPGA.
   
6. Verify the functionality using the board’s inputs (buttons/switches) and outputs (LEDs and 7-segment display).

## 🎥 Video

[https://drive.google.com/file/d/18xgqKBGixJvI2DoXaJb7VtH317SaS0FA/view?usp=sharing]

## 📝 Documentation

[VeCAD ELITE VOLUNTARY INTERNSHIP 2025 REPORT.pdf](https://github.com/user-attachments/files/25143212/VeCAD.ELITE.VOLUNTARY.INTERNSHIP.2025.REPORT.pdf)

