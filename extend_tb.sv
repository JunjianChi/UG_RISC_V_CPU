`timescale 1ns/1ps
`include "extend.sv"

module extend_tb;

    // **Inputs**
    logic [31:0] Instr;
    logic [2:0] ImmSrc;

    // **Outputs**
    logic [31:0] ImmExt;

    // **Instantiate Extend module**
    extend dut (
        .ImmExt(ImmExt),
        .Instr(Instr),
        .ImmSrc(ImmSrc)
    );

    // **Test sequence**
    initial begin
        $dumpfile("extend_tb.vcd");
        $dumpvars(0, extend_tb);

        // **Test I-type**
        Instr = 32'h00200013;
        ImmSrc = 3'b000;
        #10;
        $display("I-type | Instr = %h | ImmExt = %h | Expected: 00000002", Instr, ImmExt);

        // **Test I-type Negative**
        Instr = 32'hFFE00013;
        ImmSrc = 3'b000;
        #10;
        $display("I-type (Negative) | Instr = %h | ImmExt = %h | Expected: FFFFFFFE", Instr, ImmExt);

        // **Test S-type**
        Instr = 32'h00000023;
        ImmSrc = 3'b001;
        #10;
        $display("S-type | Instr = %h | ImmExt = %h | Expected: 00000000", Instr, ImmExt);

        // **Test B-type**
        Instr = 32'hFE000063;
        ImmSrc = 3'b010;
        #10;
        $display("B-type | Instr = %h | ImmExt = %h | Expected: FFFFF7E0", Instr, ImmExt);

        // **Test U-type**
        Instr = 32'h12345037;
        ImmSrc = 3'b011;
        #10;
        $display("U-type | Instr = %h | ImmExt = %h | Expected: 12345000", Instr, ImmExt);

        // **Test J-type**
        Instr = 32'h0056786F;
        ImmSrc = 3'b100;
        #10;
        $display("J-type | Instr = %h | ImmExt = %h | Expected: 00067804", Instr, ImmExt);

        // **End simulation**
        $finish;
    end

    // **Monitor all test cases**
    initial begin
        $monitor("t = %3d | ImmSrc = %b | Instr = %b | ImmExt = %b", 
                  $time, ImmSrc, Instr, ImmExt);
    end

endmodule
