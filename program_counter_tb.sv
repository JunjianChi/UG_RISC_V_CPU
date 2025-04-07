`timescale 1ns/1ps
`include "program_counter.sv"

module program_counter_tb;

  // Inputs
  logic CLK;
  logic Reset;
  logic [1:0] PCSrc;
  logic [31:0] PCTarget, ALUResult;

  // Outputs
  logic [31:0] PC, PCPlus4;

  // Instantiate the `program_counter` module
  program_counter dut (
    .PC(PC),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),
    .ALUResult(ALUResult),
    .PCSrc(PCSrc),
    .Reset(Reset),
    .CLK(CLK)
  );

  // Clock generation (Toggle every 10ns, 20ns period)
  initial begin
    CLK = 0;
    forever #10 CLK = ~CLK;
  end

  // Stimulus
  initial begin
    $dumpfile("program_counter_tb.vcd");
    $dumpvars(0, program_counter_tb);

    // Initialize inputs
    Reset = 1; PCSrc = 2'b00; 
    PCTarget = 32'h00000020;  // Example branch target address
    ALUResult = 32'h00000040; // Example JALR computed address
    
    // Apply Reset
    #20 Reset = 0;  

    // Test vector 1: Sequential Execution (PC + 4)
    PCSrc = 2'b00; #20;
    $display("PC = %h, Expected = 4 | PCPlus4 = %h, Expected = 8", PC, PCPlus4);

    // Test vector 2: Branch Target (PCTarget)
    PCSrc = 2'b01; #20;
    $display("PC = %h, Expected = %h | PCPlus4 = %h (unchanged)", PC, PCTarget, PCPlus4);

    // Test vector 3: JALR (ALUResult)
    PCSrc = 2'b10; #20;
    $display("PC = %h, Expected = %h | PCPlus4 = %h (unchanged)", PC, ALUResult, PCPlus4);

    // Test vector 4: Reset
    Reset = 1; #20;
    Reset = 0;
    $display("PC = %h, Expected = 0 | PCPlus4 = 4", PC, PCPlus4);

    // Additional test cases
    #20 PCSrc = 2'b00; #20;
    #20 PCSrc = 2'b01; PCTarget = 32'h00000050; #20;
    #20 PCSrc = 2'b10; ALUResult = 32'h00000080; #20;
    #20 PCSrc = 2'b00; #20;

    // Allow some additional time for simulation
    #100;
    $finish;
  end

  // Monitor PC and other signals
  initial begin
    $monitor("t = %3d, CLK = %b, Reset = %b, PCSrc = %b, PCTarget = %h, ALUResult = %h, PC = %h, PCPlus4 = %h", 
              $time, CLK, Reset, PCSrc, PCTarget, ALUResult, PC, PCPlus4);
  end

endmodule
