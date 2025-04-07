module alu (output logic signed [31:0] ALUResult,
            output logic Zero, Negative,
            input logic signed [31:0] SrcA, SrcB,
            input logic [4:0] ALUControl);

// Enter your code here

    always @(*) begin

        case (ALUControl)
            5'b10110, 5'b10010, 5'b00010, 5'b00110: ALUResult = SrcA + SrcB;
            5'b11110, 5'b11010, 5'b01010, 5'b01110: ALUResult = SrcA - SrcB;
            5'b00111, 5'b01111, 5'b10111, 5'b11111: ALUResult = SrcA | SrcB;
            5'b00011, 5'b01011, 5'b10011, 5'b11011: ALUResult = SrcA & SrcB;
            
            5'b00000, 5'b00100, 5'b01000, 5'b01100: ALUResult = SrcA << SrcB[4:0];
            5'b10000, 5'b10100, 5'b11000, 5'b11100: ALUResult = SrcA >> SrcB[4:0];
            
            5'b11001, 5'b11101, 5'b01101, 5'b01001: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0;
            
        endcase

        Zero = (ALUResult == 32'b0);
        Negative = ALUResult[31];
    end


endmodule

