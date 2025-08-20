# Spartan-6 DSP48A1 Design

## Overview
This project implements and verifies a **DSP48A1 slice of Spartan-6 FPGAs** in Verilog RTL.  
The DSP48A1 is optimized for math-intensive applications and includes a multiplier, pre-adder, post-adder/subtractor, and cascade connections.

The design flow covers:
- RTL design of DSP48A1 and submodules
- Directed testbenches in QuestaSim
- Simulation flow via DO file
- Vivado elaboration, synthesis, and implementation
- Timing, utilization, and device views
- Linting (clean runs, no errors)

---

## Features
- **Configurable attributes**: A0REG/A1REG, B0REG/B1REG, CREG, DREG, MREG, PREG, CARRYINREG, CARRYOUTREG, OPMODEREG, etc.
- **Parameters**:
  - `CARRYINSEL` → CARRYIN or OPMODE5
  - `B_INPUT` → DIRECT or CASCADE
  - `RSTTYPE` → SYNC or ASYNC
- **I/O Ports**:
  - A, B, C, D (data inputs)
  - CARRYIN, M, P, CARRYOUT, CARRYOUTF
  - Cascade: BCIN/BCOUT, PCIN/PCOUT
  - OPMODE, CLK, enables, and resets
