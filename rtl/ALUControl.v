`timescale 1ns / 1ps

`include "defines.vh"

module ALUControl (
    input  wire [2:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] alu_control
);
    always @(*) begin
        case (ALUOp)
            3'b000:  alu_control = 4'b0010;            // ADD
            3'b001:  alu_control = 4'b0011;            // SUB (branch compare)
            3'b011:  alu_control = 4'b0010;            // ADD (JAL PC+imm)
            3'b010: begin                              // R-type: look at funct3/funct7
                case (funct3)
                    `F3_ADD_SUB:  alu_control = (funct7 == `F7_SUB) ? 4'b0011 : 4'b0010; // ADD/SUB
                    `F3_AND:      alu_control = 4'b0000;
                    `F3_OR:       alu_control = 4'b0001;
                    `F3_XOR:      alu_control = 4'b0101;
                    `F3_SLT:      alu_control = 4'b0100;
                    `F3_SLTU:     alu_control = 4'b1001;
                    `F3_SLL:      alu_control = 4'b0110;
                    `F3_SRL_SRA:  alu_control = (funct7 == `F7_SRA) ? 4'b1000 : 4'b0111;
                    default:      alu_control = 4'b0010; // fallback ADD
                endcase
            end
            default: alu_control = 4'b0010;            // safe default ADD
        endcase
    end
endmodule

