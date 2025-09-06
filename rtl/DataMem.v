`timescale 1ns/1ps
module DataMem #(
    parameter DEPTH = 1024         // 1 kB = 256 words
)(
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] write_value,
    input  wire        write_enable,
    input  wire        read_enable,
    output wire [31:0] read_value   
);

    // byte-wide memory array, all values initialized as 0
    reg [7:0] mem [0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 8'h00;        // clear to zero
    end

    // combinational read  (shows up the same cycle)
    assign read_value = (read_enable) ?
                        { mem[addr+3], mem[addr+2],
                          mem[addr+1], mem[addr] } :
                        32'b0;                // bus is 0 when not reading

    //   synchronous write + safety checks
    always @(posedge clk) begin
        // detect bad requests early
        if (read_enable && write_enable)
            $fatal("DataMem: simultaneous read & write @%h", addr);

        if ((read_enable || write_enable) && addr[1:0] != 2'b00)
            $fatal("DataMem: mis-aligned %s at %h",
                   write_enable ? "write" : "read", addr);

        // write word (little-endian)
        if (write_enable) begin
            mem[addr]     <= write_value[7 :0];
            mem[addr+1]   <= write_value[15:8];
            mem[addr+2]   <= write_value[23:16];
            mem[addr+3]   <= write_value[31:24];
        end
    end

endmodule
