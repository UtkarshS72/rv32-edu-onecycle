# RV32-Edu One-Cycle CPU

A from-scratch **32-bit RISC-V (RV32I subset) single-cycle processor** written in Verilog and verified in Vivado XSim.

Built to understand datapaths, control logic, and hardware-oriented debugging.

---

## Features

- RV32I subset, single clock per instruction
- Harvard architecture (separate I-mem / D-mem)
- 32 × 32-bit register file, asynchronous reads
- Immediate generator for **I / S / B / J** formats
- ALU + dedicated ALU-control decoder
- Control-flow support
    - Branch `beq`, `bne`
    - Jump `jal`
- Load/store `lw`, `sw`
- Arithmetic `add`, `sub`, `addi`
- Byte-addressable data memory

---

## Supported Instructions

| Class | Mnemonics |
| --- | --- |
| Arithmetic | `add`, `sub`, `addi` |
| Memory | `lw`, `sw` |
| Control | `beq`, `bne`, `jal` |

---

## Datapath (single cycle)

1. **Fetch** instruction memory → `instr`
2. **Decode** control unit generates signals
3. **Read** operands from reg-file
4. **Execute** ALU / branch compare
5. **Memory** optional `lw`/`sw`
6. **Write-back** result or load-data
7. **PC update** `jal` > `branch` > `pc+4`

---

## Simulation & Verification

*Test-bench* (`sim/tb_cpu_top.sv`)

1. Loads `sample_prog.hex` into I-mem.
2. Runs for *N* cycles.
3. Peeks D-mem and asserts correctness (`$fatal`).

A Vivado waveform setup is provided (`sim/waves/cpu_wave.wcfg`) so you can reproduce the view below:

<img width="1600" height="1019" alt="image" src="https://github.com/user-attachments/assets/eeb51a3d-c70d-4327-993f-c181780b8646" />

---

## Repository Layout

rtl/            HDL source (Verilog)

sim/

├─ tb_cpu_top.sv     test-bench

├─ sample_prog.hex   demo program

└─ waves/            Vivado .wcfg file

---

## How to run (Vivado 2024.2)

1. **Create Project → RTL**
2. Add everything under `rtl/` as source.
3. Add `sim/tb_cpu_top.sv` as simulation source.
4. Copy `sample_prog.hex` into the simulation directory (or set the absolute path).
5. *Optional*: `File → Waveform Configuration → Open…` and select `sim/waves/cpu_wave.wcfg` to load the pre-defined view.
6. **Run Behavioral Simulation** – the test ends with `O BEQ/JAL test passed!`.

---

## What I Learned

- Datapath vs control separation
- Instruction decoding
- Immediate encoding formats (I/S/B/J)
- PC update logic and control hazards
- Why register file reads must be asynchronous
- Why data memory read must be combinational in a single-cycle CPU
- Hardware debugging using waveforms
- Writing self-checking testbenches

---

## Planned Improvements

- Python assembler (RISC-V → hex)
- UART peripheral
- FPGA execution (serial terminal output)
- Multi-cycle implementation
- Pipelined CPU

