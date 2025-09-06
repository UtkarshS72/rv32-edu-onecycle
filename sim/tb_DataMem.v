`timescale 1ns/1ps

module tb_DataMem;

    // Parameters
    localparam DEPTH = 1024; // bytes

    // Inputs
    reg clk;
    reg [31:0] addr;
    reg [31:0] write_value;
    reg write_enable;
    reg read_enable;

    // Output
    wire [31:0] read_value;

    // Instantiate DUT (Device Under Test)
    DataMem #(.DEPTH(DEPTH)) dut (
        .addr(addr),
        .clk(clk),
        .write_value(write_value),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .read_value(read_value)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 ns period

    initial begin
        $display("Starting test...");
        clk = 0;
        addr = 0;
        write_value = 0;
        write_enable = 0;
        read_enable = 0;

        // Wait for 2 clocks
        #10;

        // Test 1: Write 0xAABBCCDD to address 0
        addr = 32'h00000000;
        write_value = 32'hAABBCCDD;
        write_enable = 1;
        read_enable = 0;
        #10; // One clock cycle write
        write_enable = 0;

        // Test 2: Read back from address 0
        addr = 32'h00000000;
        read_enable = 1;
        #10; // Wait one clock
        $display("Read value = %h (expected AABBCCDD)", read_value);
        read_enable = 0;

        // Test 3: Write 0x11223344 to address 4
        addr = 32'h00000004;
        write_value = 32'h11223344;
        write_enable = 1;
        #10;
        write_enable = 0;

        // Test 4: Read back from address 4
        addr = 32'h00000004;
        read_enable = 1;
        #10;
        $display("Read value = %h (expected 11223344)", read_value);
        read_enable = 0;

        $display("Test complete.");
        $finish;
    end

endmodule
