`timescale 1ns/1ps
`include "control_unit.sv"

module control_unit_tb;

  // Inputs
  logic [31:0] Instr;
  logic Zero, Negative;

  // Outputs
  logic [1:0] PCSrc, ResultSrc;
  logic MemWrite, ALUSrc, RegWrite;
  logic [4:0] ALUControl;
  logic [2:0] ImmSrc;

  // Instantiate the DUT (Device Under Test)
  control_unit dut (
    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUControl(ALUControl),
    .ImmSrc(ImmSrc),
    .Instr(Instr),
    .Zero(Zero),
    .Negative(Negative)
  );

  // Test sequence
  initial begin
    $dumpfile("control_unit_tb.vcd");
    $dumpvars(0, control_unit_tb);

    // Test Case 1: R-type (ADD x5, x6, x7) - opcode: 0110011, funct3: 000, funct7: 0000000
    Instr = 32'b0000000_00110_00111_000_00101_0110011; 
    Zero = 0; Negative = 0; #10;
    $display("R-type (ADD) | PCSrc = %b, ALUControl = %b, RegWrite = %b", PCSrc, ALUControl, RegWrite);

    // Test Case 2: I-type (ADDI x5, x6, 10) - opcode: 0010011, funct3: 000
    Instr = 32'b000000000101_00110_000_00101_0010011;
    Zero = 0; Negative = 0; #10;
    $display("I-type (ADDI) | ALUSrc = %b, ALUControl = %b, RegWrite = %b", ALUSrc, ALUControl, RegWrite);

    // Test Case 3: Load Word (LW x5, 0(x6)) - opcode: 0000011, funct3: 010
    Instr = 32'b000000000000_00110_010_00101_0000011;
    Zero = 0; Negative = 0; #10;
    $display("LW | ResultSrc = %b, MemWrite = %b, RegWrite = %b", ResultSrc, MemWrite, RegWrite);

    // Test Case 4: Store Word (SW x5, 0(x6)) - opcode: 0100011, funct3: 010
    Instr = 32'b0000000_00101_00110_010_00000_0100011;
    Zero = 0; Negative = 0; #10;
    $display("SW | MemWrite = %b, ALUSrc = %b", MemWrite, ALUSrc);

    // Test Case 5: Branch if Equal (BEQ x5, x6, offset) - opcode: 1100011, funct3: 000
    Instr = 32'b0000000_00101_00110_000_00000_1100011;
    Zero = 1; Negative = 0; #10;
    $display("BEQ | PCSrc = %b", PCSrc);

    // Test Case 6: Branch if Less Than (BLT x5, x6, offset) - opcode: 1100011, funct3: 100
    Instr = 32'b0000000_00101_00110_100_00000_1100011;
    Zero = 0; Negative = 1; #10;
    $display("BLT | PCSrc = %b", PCSrc);

    // Test Case 7: JAL (Jump and Link) - opcode: 1101111
    Instr = 32'b00000000000000000000_00000_1101111;
    Zero = 0; Negative = 0; #10;
    $display("JAL | PCSrc = %b, RegWrite = %b", PCSrc, RegWrite);

    // Test Case 8: JALR (Jump and Link Register) - opcode: 1100111
    Instr = 32'b000000000000_00001_000_00000_1100111;
    Zero = 0; Negative = 0; #10;
    $display("JALR | PCSrc = %b, RegWrite = %b", PCSrc, RegWrite);

    // Test Case 9: LUI (Load Upper Immediate) - opcode: 0110111
    Instr = 32'b00000000000000000000_00000_0110111;
    Zero = 0; Negative = 0; #10;
    $display("LUI | ResultSrc = %b, RegWrite = %b", ResultSrc, RegWrite);

    // End test
    #50;
    $finish;
  end

  // Monitor values
  initial begin
    $monitor("t = %3d | Instr = %b | PCSrc = %b | ResultSrc = %b | ALUSrc = %b | ALUControl = %b | RegWrite = %b | MemWrite = %b | ImmSrc = %b", 
              $time, Instr, PCSrc, ResultSrc, ALUSrc, ALUControl, RegWrite, MemWrite, ImmSrc);
  end

endmodule
