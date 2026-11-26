#include <stdint.h>

void Con_refmodel(uint8_t OpD, uint8_t funct3D, uint8_t funct7b5D, uint8_t JumpE, uint8_t 					BranchE, uint8_t funct3E, uint8_t Z, uint8_t lts, uint8_t ltu, 
                  uint8_t *RegWriteD, uint8_t *ResultSrcD, uint8_t *MemWriteD, 
                  uint8_t *JumpD, uint8_t *BranchD, uint8_t *ALUControlD, 
                  uint8_t *ALUSrcD, uint8_t *ImmSrcD, uint8_t *PCSrcE)
{
    switch (OpD) {
        case 3: // Load-type
            *RegWriteD = 1;
            *ResultSrcD = 1;    // Load result from memory
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 0;
            *ALUControlD = 0;   // ADD for address calculation
            *ALUSrcD = 1;       // Use immediate for address calculation
            *ImmSrcD = 0;       // Immediate for load
            break;

        case 19: // I-type Instructions
            *RegWriteD = 1;
            *ResultSrcD = 0;    // Load result from ALU into Register File
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 0;

            switch (funct3D) {
                case 0: *ALUControlD = 0; break; // ADDI
                case 1: *ALUControlD = 2; break; // SLLI
                case 2: *ALUControlD = 3; break; // SLTI
                case 3: *ALUControlD = 4; break; // SLTIU
                case 4: *ALUControlD = 5; break; // XORI
                case 5: *ALUControlD = (funct7b5D == 0) ? 6 : 7; break; // SRLI or SRAI
                case 6: *ALUControlD = 8; break; // ORI
                case 7: *ALUControlD = 9; break; // ANDI
                default: *ALUControlD = 0; break; // Default to ADDI for unknown funct3D
            }

            *ALUSrcD = 1;       // Use immediate for address calculation
            *ImmSrcD = 0;       // Immediate for I-type
            break;

        case 23: // U-type
            *RegWriteD = 1;
            *ResultSrcD = 3;    // Load result from PC + SignExt Adder
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 0;
            *ALUControlD = 0;   // Not required
            *ALUSrcD = 0;       // Not required 
            *ImmSrcD = 3;       
            break;

        case 35: // S-type 
            *RegWriteD = 0;
            *ResultSrcD = 0;    // Not needed for S-type
            *MemWriteD = 1;     
            *JumpD = 0;
            *BranchD = 0;
            *ALUControlD = 0;   // ADD for address calculation
            *ALUSrcD = 1;       // Use immediate for address calculation
            *ImmSrcD = 1;       // Immediate for load
            break;

        case 51: // R-type
            *RegWriteD = 1;
            *ResultSrcD = 0;    // Load result from ALU into Register File
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 0;

            switch (funct3D) {
                case 0: *ALUControlD = (funct7b5D == 0) ? 0 : 1; break; // ADDI or SUB
                case 1: *ALUControlD = 2; break; // SLLI
                case 2: *ALUControlD = 3; break; // SLTI
                case 3: *ALUControlD = 4; break; // SLTIU
                case 4: *ALUControlD = 5; break; // XORI
                case 5: *ALUControlD = (funct7b5D == 0) ? 6 : 7; break; // SRLI or SRAI
                case 6: *ALUControlD = 8; break; // ORI
                case 7: *ALUControlD = 9; break; // ANDI
                default: *ALUControlD = 0; break; // Default to ADDI for unknown funct3D
            }

            *ALUSrcD = 0;       // Use register for R-type
            *ImmSrcD = 0;       // Not needed for R-type
            break;

        case 55: // U-type (LUI)
            *RegWriteD = 1;
            *ResultSrcD = 4;    // Load result from SignExt into Register File
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 0;
            *ALUControlD = 0;   // Not required as only Sign Extension is needed
            *ALUSrcD = 0;       // Not required
            *ImmSrcD = 3;       
            break;
        
        case 99: //B-type
            *RegWriteD = 0;
            *ResultSrcD = 0;    // Not needed for B-type
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 1;
            *ALUControlD = 1;   // SUB for comparison
            *ALUSrcD = 0;       // Use register for B-type
            *ImmSrcD = 2;       // Immediate for B-type
            break;    
        
        case 103: //jalr
            *RegWriteD = 1;
            *ResultSrcD = 2;    //PC+4 is stored in the register file 
            *MemWriteD = 0;     
            *JumpD = 1;
            *BranchD = 0;
            *ALUControlD = 0;   // Not required
            *ALUSrcD = 0;       // Not required
            *ImmSrcD = 4;       // Immediate for JALR
            break;
        
        case 111: //jal
            *RegWriteD = 1;
            *ResultSrcD = 2;    //PC+4 is stored in the register file
            *MemWriteD = 0;     
            *JumpD = 1;
            *BranchD = 0;
            *ALUControlD = 0;   // Not required
            *ALUSrcD = 0;       // Not required
            *ImmSrcD = 4;       // Immediate for JAL
            break;

        default: 
            // Handle unknown OpD values if necessary
            *RegWriteD = 0;
            *ResultSrcD = 0;    
            *MemWriteD = 0;     
            *JumpD = 0;
            *BranchD = 0;
            *ALUControlD = 0;   
            *ALUSrcD = 0;       
            *ImmSrcD = 0;       
            break;
    }

//PCSrcE Logic
    if(*JumpD && OpD == 103)
        *PCSrcE = 2; // JALR
    else if(*JumpD && OpD == 111)
        *PCSrcE = 1; // JAL
    else if(OpD == 99) {
        switch(funct3E) {
            case 0: *PCSrcE = (Z)    & BranchE ? 1 : 0; break; // BEQ
            case 1: *PCSrcE = (!Z)   & BranchE ? 1 : 0; break; // BNE
            case 4: *PCSrcE = (lts)  & BranchE ? 1 : 0; break; // BLT
            case 5: *PCSrcE = (!lts) & BranchE ? 1 : 0; break; // BGE
            case 6: *PCSrcE = (ltu)  & BranchE ? 1 : 0; break; // BLTU
            case 7: *PCSrcE = (!ltu) & BranchE ? 1 : 0; break; // BGEU
            default: *PCSrcE = 0; break; // Default to no branch for unknown funct3E
        }
    }
    else 
        *PCSrcE = 0; // Default to no branch
}