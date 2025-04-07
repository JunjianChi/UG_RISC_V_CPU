module reg_file   (output logic [31:0] RD1, RD2,
                    input logic [31:0] WD3,
                    input logic [4:0] A1, A2, A3,
                    input logic WE3, CLK);

logic [31:0] RF [0:31];

assign RD1 = (A1==5'b0) ? 32'b0 : RF[A1];
assign RD2 = (A2==5'b0) ? 32'b0 : RF[A2];

always_ff @ (posedge CLK)
if (WE3) RF[A3] <= WD3;

endmodule