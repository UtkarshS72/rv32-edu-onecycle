`timescale 1ns / 1ps

module ALU (
    input wire [31:0] input1,
    input wire [31:0] input2,
    input wire [3:0] alu_control,
    output reg [31:0] result,
    output wire zero
);

always @(*) begin
    case (alu_control)
        4'b0000: result = input1 & input2;                                       // AND
        4'b0001: result = input1 | input2;                                       // OR
        4'b0010: result = input1 + input2;                                       // ADD
        4'b0011: result = input1 - input2;                                       // SUB
        4'b0100: result = ($signed(input1) < $signed(input2)) ? 32'b1 : 32'b0;   // SLT (signed)
        4'b0101: result = input1 ^ input2;                                       // XOR
        4'b0110: result = input1 << input2[4:0];                                 // SLL
        4'b0111: result = input1 >> input2[4:0];                                 // SRL (logical)
        4'b1000: result = $signed(input1) >>> input2[4:0];                       // SRA (arithmetic)
        4'b1001: result = (input1 < input2) ? 32'b1 : 32'b0;                     // SLTU (unsigned)
        4'b1010: result = ~(input1 | input2);                                    // NOR
        default: result = 32'b0;                                                 // default
    endcase
end

assign zero = (result == 0);

endmodule
