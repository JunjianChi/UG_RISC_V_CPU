`include "instruction_memory.sv"
`include "reg_file.sv"
`include "extend.sv"
`include "alu.sv"
`include "data_memory_and_io.sv"
`include "program_counter.sv"
`include "control_unit.sv"

module risc_v(output logic [31:0] CPUOut,
                input logic [31:0] CPUIn,
                input logic Reset, CLK);

logic [31:0] Instr, WD3, RD1, RD2, SrcA, SrcB, ALUResult, WD, RD, Result, ImmExt, PCTarget, PCNext, PC, PCPlus4;
logic [4:0]  A1, A2, A3;
logic        MemWrite, ALUSrc, RegWrite;
logic        Zero, Negative;
logic [4:0]  ALUControl;
logic [2:0]  ImmSrc;
logic [1:0]  ResultSrc;
logic [1:0]  PCSrc;

// Enter your code here
assign PCTarget = PC + ImmExt; 

program_counter program_counter_inst (
    .PC(PC), 
    .PCPlus4(PCPlus4), 
    .PCTarget(PCTarget), 
    .ALUResult(ALUResult), 
    .PCSrc(PCSrc), 
    .Reset(Reset), 
    .CLK(CLK)
);


instruction_memory instruction_memory_inst (
    .PC(PC),
    .Instr(Instr)
);


control_unit control_unit_inst (
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


assign A1 = Instr[19:15]; // rs1
assign A2 = Instr[24:20]; // rs2
assign A3 = Instr[11:7];  // rd

reg_file reg_file_inst (
    .RD1(RD1),
    .RD2(RD2),
    .WD3(WD3),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WE3(RegWrite),
    .CLK(CLK)
);


extend extend_inst (
    .Instr(Instr),  
    .ImmSrc(ImmSrc),      
    .ImmExt(ImmExt)      
);


assign SrcA = RD1;
assign SrcB = (ALUSrc) ? ImmExt : RD2; // Select SrcB based on ALUSrc control

alu alu_unit (
    .ALUResult(ALUResult),
    .Zero(Zero),
    .Negative(Negative),
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl)
);


data_memory_and_io data_mem (
    .RD(RD),
    .CPUOut(CPUOut),
    .A(ALUResult),
    .WD(RD2),
    .CPUIn(CPUIn),
    .WE(MemWrite),
    .CLK(CLK)
);


always_comb begin
    case (ResultSrc)
        2'b00: Result = ImmExt;  
        2'b01: Result = ALUResult;  
        2'b10: Result = RD;        
        2'b11: Result = PCPlus4;  
        default: Result = 32'b0;
    endcase
end

assign WD3 = Result;


endmodule

