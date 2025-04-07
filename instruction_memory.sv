module instruction_memory (output logic [31:0] Instr,
                            input logic [31:0] PC);

logic [7:0] IM [0:255];
logic [31:0] prog [0:63];
logic [31:0] PC_divided_by_4;

initial
$readmemh ("program2.txt", prog);

assign Instr = prog[PC_divided_by_4];

assign PC_divided_by_4 = PC/4;

endmodule