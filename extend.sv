module extend (output logic [31:0] ImmExt,
                input logic [31:0] Instr,
                input logic [2:0] ImmSrc);

// Enter your code here


    always @(*) begin
        case (ImmSrc)
            3'b000: // I-type (e.g., LW, JALR, arithmetic immediates)
                ImmExt = {{20{Instr[31]}}, Instr[31:20]};  
            3'b001: // S-type (e.g., SW)
                ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};  
            3'b010: // B-type (e.g., BEQ, BNE, BLT, BGE)
                ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};  
            3'b011: // U-type (e.g., LUI, AUIPC)
                ImmExt = {Instr[31:12], 12'b0};  
            3'b100: // J-type (e.g., JAL)
                ImmExt = {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0};  
            default:
                ImmExt = 32'b0;
        endcase
    end


endmodule