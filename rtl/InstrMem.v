`timescale 1ns / 1ps

module InstrMem #(
    parameter DEPTH = 256
)(
    input  wire [31:0] addr,   // byte address from PC
    output wire [31:0] instr
);

    localparam INDEX_BITS = $clog2(DEPTH); // to calculate which bits are used
    localparam INDEX_MSB = 2 + INDEX_BITS - 1; // 2 + log2 DEPTH -1. log2 DEPTH  will calculate how many bits, the rest will adjust

    reg [31:0] mem [0:DEPTH-1]; // defining the array

    initial $readmemh("sample_prog.hex", mem);   //read a hex file with instructions, keep the file in the same directory

    assign instr = mem[ addr[INDEX_MSB:2] ];  // first 2 bits are discarded for alignment by 4's

endmodule
