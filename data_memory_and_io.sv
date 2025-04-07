module data_memory_and_io (output logic [31:0] RD, CPUOut,
                            input logic [31:0] A, WD, CPUIn,
                            input logic WE, CLK);

logic [7:0] DM [0:1023];
logic RDsel, WEM, WEOut;

assign RDsel = (A == 32'h7FFFFFFC) ? 1 : 0; 

assign RD = (RDsel) ? CPUIn : {DM[A+3], DM[A+2], DM[A+1], DM[A]};

always_comb
begin
   if ((WE) & (A == 32'h7FFFFFFC)) begin
        WEOut = 1;
        WEM = 0;
    end
    else if ((WE) & (A != 32'h7FFFFFFC)) begin
        WEOut = 0;
        WEM = 1;
    end
    else begin
        WEOut = 0;
        WEM = 0;
    end        
end

always_ff @ (posedge CLK)
begin
    if (WEM)  {DM [A+3], DM [A+2], DM [A+1], DM [A]} <= WD;
    if (WEOut) CPUOut <= WD;
end

endmodule
