`timescale 1ns / 1ps

module PC #(
    parameter RESET_ADDRESS = 32'h40000000) (
    input wire clk, 
    input wire rst,
    input wire [31:0] pc_next, 
    output reg [31:0] pc
);

always@(posedge clk) begin

    pc <= rst? RESET_ADDRESS : pc_next;  // pc_next is calculated in the top module

end

endmodule