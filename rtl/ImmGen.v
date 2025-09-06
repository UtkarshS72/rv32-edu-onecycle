`timescale 1ns / 1ps

`include "defines.vh"

module ImmGen(
    input  wire [31:0] instr,
    input  wire [2:0]  ImmSel,     // one of IMM_I/S/B/J
    output reg  [31:0] imm_out     // sign-extended; for B/J include <<1
);

    always@(*) begin
        imm_out = 32'b0; // setting a default
        case(ImmSel)            
            `IMM_I: imm_out = {{20{instr[31]}}, instr[31:20]};
            `IMM_S: imm_out = {{20{instr[31]}},instr[31:25],instr[11:7]};
            `IMM_B: imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            `IMM_J: imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            `IMM_NONE: imm_out = 32'b0;
            default: ;  // empty for now
            
        endcase
    end 
    
    
    
endmodule
