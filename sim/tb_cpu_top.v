`timescale 1ns/1ps
module tb_cpu_top;
    reg clk  = 0;
    reg rst  = 1;

    // clock generator: 10 ns period
    always #5 clk = ~clk;

    // DUT
    CPU_top dut (
        .clk (clk),
        .rst (rst),
        .dbg_pc     (),   // unused for this TB
        .dbg_instr  ()
    );

    // release reset after a few cycles
    initial begin
        #15  rst = 0;
    end

    //  Probe the internal RAM after N cycles
    
    always @(posedge clk) $display("%0t ns  PC=%08h", $time, dut.dbg_pc);

    
    initial begin
        // run long enough for all instructions to execute
        #(200) ;

        // hierarchical reference:
        //   dut  -> CPU_top instance
        //   dmem_i -> DataMem inside CPU_top
        //   mem    -> the reg [7:0] mem [0:DEPTH-1] array
        // Word 0x0004 = byte addresses 4..7
        $display("mem[4]  = %h%h%h%h",
                 dut.dmem_i.mem[7],
                 dut.dmem_i.mem[6],
                 dut.dmem_i.mem[5],
                 dut.dmem_i.mem[4]);

        //   {mem[7:4]} is SystemVerilog; classic Verilog uses
        //   {dut.dmem_i.mem[7], dut.dmem_i.mem[6], ...}

        // automatic check
        if ( {dut.dmem_i.mem[7],
              dut.dmem_i.mem[6],
              dut.dmem_i.mem[5],
              dut.dmem_i.mem[4]} !== 32'h0000_0055 )
            $fatal(1, "X  Store did not write 0x0000_0055 to address 4" );

        $display("O BEQ/JAL test passed!");
        $finish;
    end
endmodule

