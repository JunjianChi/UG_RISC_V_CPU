module control_unit (output logic [1:0] PCSrc, 
                    output logic [1:0] ResultSrc,
                    output logic MemWrite, ALUSrc, RegWrite,
                    output logic [4:0] ALUControl,
                    output logic [2:0] ImmSrc,
                    input logic [31:0] Instr,
                    input logic Zero, Negative);

// Enter your code here

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = Instr[6:0];   // Opcode: 
    assign funct3 = Instr[14:12]; // Funct3: 
    assign funct7 = Instr[31:25]; // Funct7: R 

    // **1. Immsrc**
    always_comb begin
        case (opcode)
            7'b0000011: ImmSrc = 3'b000; // I (LW)
            7'b0010011: ImmSrc = 3'b000; // I (Arithmetic)
            7'b1100111: ImmSrc = 3'b000; // I (JALR)
            7'b0100011: ImmSrc = 3'b001; // S (SW)
            7'b1100011: ImmSrc = 3'b010; // B (Branch)
            7'b0110111: ImmSrc = 3'b011; // U (LUI)
            7'b1101111: ImmSrc = 3'b100; // J (JAL)
            default: ImmSrc = 3'b000;    
        endcase
    end

    // **2. PCSrc**
    always_comb begin
        case (opcode)
            7'b1100011: // (BEQ, BNE, BLT, BGE)
                PCSrc = (funct3 == 3'b000 && Zero)  ? 2'b01 :  // BEQ
                        (funct3 == 3'b001 && !Zero) ? 2'b01 :  // BNE
                        (funct3 == 3'b100 && Negative) ? 2'b01 : // BLT
                        (funct3 == 3'b101 && !Negative) ? 2'b01 : // BGE
                        2'b00; 
            7'b1101111: PCSrc = 2'b01; // JAL
            7'b1100111: PCSrc = 2'b10; // JALR 
            default: PCSrc = 2'b00; 
        endcase
    end

    // **3. ResultSrc**
    always_comb begin
        case (opcode)
            7'b0000011: ResultSrc = 2'b10; // LW 
            7'b1101111: ResultSrc = 2'b11; // JAL 
            7'b1100111: ResultSrc = 2'b11; // JALR (PC+4)
            7'b0110111: ResultSrc = 2'b00; // LUI 
            7'b0010011, 
            7'b0110011: ResultSrc = 2'b01; // I & R
            default: ResultSrc = 2'b00;    
        endcase
    end

    // **4. ALUSrc**
    assign ALUSrc = (opcode == 7'b0010011 ||  // I (Arithmetic)
                     opcode == 7'b0000011 ||  // I (LW)
                     opcode == 7'b0100011 ||  // S (SW)
                     opcode == 7'b1100111);   // I (JALR)

    // **5. MemWrite**
    assign MemWrite = (opcode == 7'b0100011); // SW 

    // **6. RegWrite**
    assign RegWrite = (opcode == 7'b0110011 ||  // R 
                       opcode == 7'b0010011 ||  // I 
                       opcode == 7'b0000011 ||  // LW
                       opcode == 7'b1101111 ||  // JAL
                       opcode == 7'b1100111 ||  // JALR
                       opcode == 7'b0110111);   // LUI

    // **7. ALUControl**
    always_comb begin
        case (opcode)
            7'b0110011: begin // **R 
                case ({funct7, funct3})
                    10'b0000000000: ALUControl = 5'b00110; // ADD
                    10'b0100000000: ALUControl = 5'b01010; // SUB
                    10'b0000000110: ALUControl = 5'b00111; // OR
                    10'b0000000111: ALUControl = 5'b00011; // AND
                    10'b0000000001: ALUControl = 5'b00000; // SLL
                    10'b0000000101: ALUControl = 5'b10000; // SRL
                    10'b0000000010: ALUControl = 5'b01001; // SLT
                    default: ALUControl = 5'b00000; // 
                endcase
            end

            7'b0010011: begin // **I
                case (funct3)
                    3'b000: ALUControl = 5'b00110; // ADDI
                    3'b110: ALUControl = 5'b00111; // ORI
                    3'b111: ALUControl = 5'b00011; // ANDI
                    3'b001: ALUControl = 5'b00000; // SLLI
                    3'b101: ALUControl = 5'b10000; // SRLI
                    3'b010: ALUControl = 5'b01001; // SLTI
                    default: ALUControl = 5'b00000;
                endcase
            end

            7'b0000011, // **LW** 
            7'b0100011, // **SW** 
            7'b1100111: // **JALR**
                ALUControl = 5'b00110; 

            7'b1100011: begin // **Branch**
                case (funct3)
                    3'b000, // BEQ
                    3'b001, // BNE
                    3'b100, // BLT
                    3'b101: // BGE
                        ALUControl = 5'b01010; 
                    default: ALUControl = 5'b00000;
                endcase
            end

            7'b1101111: ALUControl = 5'b00000; // JAL
            7'b0110111: ALUControl = 5'b00000; // LUI

            default: ALUControl = 5'b00000; 
        endcase
    end



endmodule