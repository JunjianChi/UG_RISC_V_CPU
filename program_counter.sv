module program_counter (output logic [31:0] PC, PCPlus4,
                        input logic [31:0] PCTarget, ALUResult,
                        input logic [1:0] PCSrc, 
                        input logic Reset, CLK);

// Enter your code here

    assign PCPlus4 = PC + 4;

    // Synchronous PC update with reset
    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset) begin
            PC <= 32'b0;  // Reset PC to 0 (start executing from 0x00000000)
        end else begin
            case (PCSrc)
                2'b00: PC <= PCPlus4;   // Sequential execution (PC + 4)
                2'b01: PC <= PCTarget;  // Branch target address
                2'b10: PC <= ALUResult; // JALR computed target
                default: PC <= PCPlus4; // Default case: fall back to sequential
            endcase
        end
    end

endmodule

