`timescale 1ns/1ps
`include "alu.sv"

module alu_tb;

    // **Inputs**
    logic signed [31:0] SrcA, SrcB;
    logic [4:0] ALUControl;

    // **Outputs**
    logic signed [31:0] ALUResult;
    logic Zero, Negative;

    // **Instantiate ALU module**
    alu dut (
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Negative(Negative),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl)
    );

    // **Test sequence**
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // **Test ADD**
        SrcA = 32'd10;
        SrcB = 32'd5;
        ALUControl = 5'b00010;
        #10;
        $display("ADD | SrcA = %0d, SrcB = %0d | ALUResult = %0d", SrcA, SrcB, ALUResult);

        // **Test SUB**
        SrcA = 32'd20;
        SrcB = 32'd5;
        ALUControl = 5'b11110;
        #10;
        $display("SUB | SrcA = %0d, SrcB = %0d | ALUResult = %0d", SrcA, SrcB, ALUResult);

        // **Test OR**
        SrcA = 32'h0F0F0F0F;
        SrcB = 32'hF0F0F0F0;
        ALUControl = 5'b00111;
        #10;
        $display("OR  | SrcA = %h, SrcB = %h | ALUResult = %h", SrcA, SrcB, ALUResult);

        // **Test AND**
        SrcA = 32'h0F0F0F0F;
        SrcB = 32'hF0F0F0F0;
        ALUControl = 5'b00011;
        #10;
        $display("AND | SrcA = %h, SrcB = %h | ALUResult = %h", SrcA, SrcB, ALUResult);

       // **Test Logical Left Shift (SLL)**
        SrcA = 32'h00000002;
        SrcB = 32'h00000002; // shift by 2
        ALUControl = 5'b00000;
        #10;
        $display("SLL | SrcA = %0d, SrcB = %0d | ALUResult = %0d (Expected: 8)", SrcA, SrcB, ALUResult);

        // **Test Logical Right Shift (SRL)**
        SrcA = 32'h00000080;
        SrcB = 32'h00000003; // shift by 3
        ALUControl = 5'b10000;
        #10;
        $display("SRL | SrcA = %0d, SrcB = %0d | ALUResult = %0d (Expected: 16)", SrcA, SrcB, ALUResult);

        // **Test Zero flag**
        SrcA = 32'd10;
        SrcB = 32'd10;
        ALUControl = 5'b11110; // 10 - 10 = 0
        #10;
        $display("ZERO TEST | SrcA = %0d, SrcB = %0d | ALUResult = %0d | Zero = %b", SrcA, SrcB, ALUResult, Zero);

        // **Test Negative flag**
        SrcA = 32'd5;
        SrcB = 32'd10;
        ALUControl = 5'b11110; // 5 - 10 = -5
        #10;
        $display("NEGATIVE TEST | SrcA = %0d, SrcB = %0d | ALUResult = %0d | Negative = %b", SrcA, SrcB, ALUResult, Negative);

        // **End simulation**
        #50;
        $finish;
    end

    // **Monitor ALU computations**
    initial begin
        $monitor("t = %3d | ALUControl = %b | SrcA = %0d (%h) | SrcB = %0d (%h) | ALUResult = %0d (%h) | Zero = %b | Negative = %b", 
                  $time, ALUControl, SrcA, SrcA, SrcB, SrcB, ALUResult, ALUResult, Zero, Negative);
    end

endmodule
