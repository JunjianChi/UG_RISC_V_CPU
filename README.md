# UG_RISC_V_CPU

A simplified RISC-V CPU core implemented in Verilog/SystemVerilog as part of an undergraduate digital design project.

This CPU supports basic RISC-V instructions and has been modularly designed and tested using multiple testbenches and waveform simulations.

---

## 🧠 Features

- Modular RISC-V datapath:
  - **ALU**
  - **Register File**
  - **Control Unit**
  - **Program Counter**
  - **Instruction & Data Memory**
  - **Immediate Generator**
- Testbenches (`*_tb.sv`) for each module
- Waveform outputs in `.vcd` format for debugging and verification

---

## 📁 File Overview

| File / Folder            | Description                                   |
|--------------------------|-----------------------------------------------|
| `alu.sv`, `alu_tb.sv`    | Arithmetic Logic Unit and its testbench       |
| `control_unit.sv`        | Control logic (opcode to control signal)      |
| `data_memory_and_io.sv`  | Data memory module                            |
| `instruction_memory.sv`  | ROM for instruction fetch                     |
| `program_counter.sv`     | PC increment and update logic                 |
| `reg_file.sv`            | Register file supporting read/write ops       |
| `extend.sv`              | Immediate extension unit                      |
| `risc_v.sv`              | Top-level RISC-V CPU integration              |
| `*_tb.v`, `*.vcd`        | All module-specific testbenches and waveform |
| `program*.txt`           | Instruction memory content in plain text      |

---

## 🛠️ How to Simulate

1. Use [ModelSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html), [Verilator](https://www.veripool.org/verilator/), or other Verilog simulator.
2. Compile source and testbench files.
3. Run simulation and open `.vcd` waveforms to verify outputs.

Example (using Icarus Verilog + GTKWave):

```bash
iverilog -g 2012 -o risc_v_tb.vvp risc_v_tb.sv
vvp risc_v_tb.vvp
gtkwave
