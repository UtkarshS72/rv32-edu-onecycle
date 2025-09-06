`timescale 1ns / 1ps

module RegisterFile (
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire [4:0] read_address1,
    input wire [4:0] read_address2,
    input wire [4:0] write_address,
    input wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2   
);

reg [31:0] registers [31:0];

assign read_data1 = (read_address1 == 0) ? 32'b0 : registers[read_address1];

assign read_data2 = (read_address2 == 0) ? 32'b0 : registers[read_address2];


integer i;
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'h0;
    end
    else if (write_enable && write_address != 0)
        registers[write_address] <= write_data;
end

endmodule