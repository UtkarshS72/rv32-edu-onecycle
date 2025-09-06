`timescale 1ns/1ps
`include "defines.vh"          // keep the header in the same directory

module CPU_top (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] dbg_pc,      // program-counter for waveform
    output wire [31:0] dbg_instr    // current instruction
);
    // 1.  Program-counter & Instruction memory
    wire [31:0] pc_current, pc_next;
    wire [31:0] instruction;

    PC pc_i (
        .clk     (clk),
        .rst     (rst),
        .pc_next (pc_next),
        .pc      (pc_current)
    );

    assign dbg_pc  = pc_current;
    //pc_next is calculated further down

    InstrMem imem_i (
        .addr  (pc_current),
        .instr (instruction)
    );
    assign dbg_instr = instruction;

    // 2.  Instruction field decoding
    wire [4:0] rs1   = instruction[19:15];
    wire [4:0] rs2   = instruction[24:20];
    wire [4:0] rd    = instruction[11:7];
    wire [2:0] funct3= instruction[14:12];
    wire [6:0] funct7= instruction[31:25];

    // 3.  Main control  +  Immediate generator
    wire        RegWrite, MemRead, MemWrite, MemToReg, ALUSrc;
    wire        Branch, BranchNE, Jump;   
    wire [2:0]  ALUOp, ImmSel;

    MainControl ctrl_i (
        .opcode   (instruction[6:0]),
        .funct3   (funct3),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .MemToReg (MemToReg),
        .ALUSrc   (ALUSrc),
        .Branch   (Branch),
        .BranchNE (BranchNE),
        .Jump     (Jump),
        .ALUOp    (ALUOp),
        .ImmSel   (ImmSel)
    );

    wire [31:0] imm_out;
    ImmGen imm_i (
        .instr   (instruction),
        .ImmSel  (ImmSel),
        .imm_out (imm_out)
    );

    // 4.  Register-file  (two extra taps for debug)
    wire [31:0] rf_rdata1, rf_rdata2;
    wire [31:0] rf_wdata;
    wire [31:0] rf_reg10, rf_reg6;

    RegisterFile rf_i (
        .clk           (clk),
        .rst           (rst),
        .write_enable  (RegWrite),
        .read_address1 (rs1),
        .read_address2 (rs2),
        .write_address (rd),
        .write_data    (rf_wdata),
        .read_data1    (rf_rdata1),
        .read_data2    (rf_rdata2)
    );
    

    // 5.  ALU  +  ALU-control
    wire [3:0]  alu_ctl;
    wire [31:0] alu_in2  = ALUSrc ? imm_out : rf_rdata2;
    wire [31:0] alu_res;
    wire        alu_zero;

    ALUControl alu_ctl_i (
        .ALUOp      (ALUOp),
        .funct3     (funct3),
        .funct7     (funct7),
        .alu_control(alu_ctl)
    );

    ALU alu_i (
        .input1     (rf_rdata1),
        .input2     (alu_in2),
        .alu_control(alu_ctl),
        .result     (alu_res),
        .zero       (alu_zero)
    );

    // 6.  Data memory  (byte-addressable, word-aligned)
    wire [31:0] dmem_rdata;

    DataMem #(.DEPTH(1024)) dmem_i (
        .clk          (clk),
        .addr         (alu_res),
        .write_value  (rf_rdata2),
        .write_enable (MemWrite),
        .read_enable  (MemRead),
        .read_value   (dmem_rdata)
    );

    // 7.  Write-back MUX  (MemToReg ? DMEM : ALU)
    wire [31:0] pc_plus4      = pc_current + 32'd4;

    assign rf_wdata = Jump ? pc_plus4 : MemToReg ? dmem_rdata : alu_res;

    wire [31:0] branch_target = pc_current + imm_out; // imm_out = B-imm <<1
    wire [31:0] jump_target   = pc_current + imm_out; // J-imm <<1 (same adder)

    // priority: jump > branch > pc_current +4
    assign pc_next =
        Jump                          ? jump_target   :
        (Branch  &&  alu_zero)        ? branch_target :
        (BranchNE && !alu_zero)       ? branch_target :
                                        pc_plus4;
 

endmodule
