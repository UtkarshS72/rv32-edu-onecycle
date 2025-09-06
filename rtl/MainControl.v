`timescale 1ns / 1ps

`include "defines.vh"

module MainControl (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,      // only for BEQ/BNE row
    output reg        RegWrite,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        MemToReg,
    output reg        ALUSrc,
    output reg        Branch,
    output reg        BranchNE,
    output reg        Jump,
    output reg [2:0]  ALUOp,
    output reg [2:0] ImmSel
);
    always @(*) begin
        // default all signals
        RegWrite  = 0;
        MemRead   = 0;
        MemWrite  = 0;
        MemToReg  = 0;
        ALUSrc    = 0;
        Branch    = 0;
        BranchNE  = 0;
        Jump      = 0;
        ALUOp     = 3'b000;
        ImmSel = `IMM_NONE;

        case (opcode)
            `OPC_RTYPE: begin
                RegWrite  = 1;
                MemRead   = 0;
                MemWrite  = 0;
                MemToReg  = 0;
                ALUSrc    = 0;
                Branch    = 0;
                BranchNE  = 0;
                Jump      = 0;
                ALUOp     = 3'b010;  // “R-type group”
                ImmSel = `IMM_NONE;

            end
            `OPC_ITYPE: begin // ADDI
                RegWrite  = 1;
                MemRead   = 0;
                MemWrite  = 0;
                MemToReg  = 0;
                ALUSrc    = 1;
                Branch    = 0;
                BranchNE  = 0;
                Jump      = 0;
                ALUOp     = 3'b000;  // "ADDI group"
                ImmSel = `IMM_I;

            end
            `OPC_LW: begin
                RegWrite  = 1;
                MemRead   = 1;
                MemWrite  = 0;
                MemToReg  = 1;
                ALUSrc    = 1;
                Branch    = 0;
                BranchNE  = 0;
                Jump      = 0;
                ALUOp     = 3'b000;  // "LW group"
                ImmSel = `IMM_I;

            end
            `OPC_SW: begin
                RegWrite  = 0;
                MemRead   = 0;
                MemWrite  = 1;
                MemToReg  = 0;
                ALUSrc    = 1;
                Branch    = 0;
                BranchNE  = 0;
                Jump      = 0;
                ALUOp     = 3'b000;  // "SW group"
                ImmSel = `IMM_S;

            end
            `OPC_BRANCH: begin
                // need funct3 to tell BEQ vs BNE
                case (funct3)
                    3'b000: begin // BEQ
                        RegWrite  = 0;
                        MemRead   = 0;
                        MemWrite  = 0;
                        MemToReg  = 0;
                        ALUSrc    = 0;
                        Branch    = 1;
                        BranchNE  = 0;
                        Jump      = 0;
                        ALUOp     = 3'b001;
                        ImmSel = `IMM_B;
  
                    end
                    3'b001: begin // BNE
                        RegWrite  = 0;
                        MemRead   = 0;
                        MemWrite  = 0;
                        MemToReg  = 0;
                        ALUSrc    = 0;
                        Branch    = 0;
                        BranchNE  = 1;
                        Jump      = 0;
                        ALUOp     = 3'b001;
                        ImmSel = `IMM_B;

                    end
                    default: ; // unsupported
                endcase
            end
            `OPC_JAL: begin
                RegWrite  = 1;
                MemRead   = 0;
                MemWrite  = 0;
                MemToReg  = 0;
                ALUSrc    = 1;
                Branch    = 0;
                BranchNE  = 0;
                Jump      = 1;
                ALUOp     = 3'b011;  // "JAL group"
                ImmSel = `IMM_J;

            end
            default: ; // unsupported opcode
        endcase
    end
endmodule

