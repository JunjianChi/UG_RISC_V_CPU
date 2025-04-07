`timescale 1ns/1ps
`include "risc_v.sv"

module risc_v_tb;
logic [31:0] CPUOut, CPUIn;
logic Reset, CLK;

risc_v dut(CPUOut, CPUIn, Reset, CLK);

initial begin // Generate clock signal with 20 ns period
CLK = 0;
forever #10 CLK = ~CLK;
end

initial begin // Apply stimulus

// Enter your code here
$dumpfile("risc_v_tb.vcd"); 
$dumpvars(0, risc_v_tb);     

Reset = 1;  
CPUIn = 32'b0;  
// Step 2: Release reset
#20 Reset = 0;
$display("CPU Reset Done");
// Step 3: Run CPU for several clock cycles
repeat (80) begin
    #20; 
    CPUIn = 0; 
end

// Step 4: End simulation
$display("Simulation complete.");

$finish; // This system tasks ends the simulation
end

always @ (negedge CLK)
$display ("t = %3d, CPUIn = %d, CPUOut = %d, Reset = %b, PCSrc = %b PC = %d, PCTarget = %h, ImmExt = %h, Instr = %h, ALUResult = %d", $time, CPUIn, CPUOut, Reset, dut.PCSrc, dut.PC, dut.PCTarget, dut.ImmExt, dut.Instr, dut.ALUResult);

endmodule
