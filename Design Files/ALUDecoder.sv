`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 15:19:07
// Design Name: Controller
// Module Name: ALUDecoder
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUDecoder(
    input  logic [1:0] ALUOp,
    input  logic [2:0] funct3D,
    input  logic       funct7b5D,
    output logic [3:0] ALUControlE
    );
    
    always_comb begin
        case(ALUOp)
        2'b00: ALUControlE = 4'b0000;           //addition for Load, add, addi instructions 
        2'b01: ALUControlE = 4'b0001;           //subraction for B-type, sub, subi instructions 
        default: 
        //-----------------------------R & I-type Instructions---------------------------------//
            case(funct3D)        
            3'b000: begin
                if (funct7b5D == 1'b0)
                    ALUControlE = 4'b0000;      //add                
                else
                    ALUControlE = 4'b0001;      //sub
                    end
            3'b001: ALUControlE = 4'b0010;      //sll
            3'b010: ALUControlE = 4'b0011;      //slt
            3'b011: ALUControlE = 4'b0100;      //sltu
            3'b100: ALUControlE = 4'b0101;      //xor
            3'b101: begin
                if (funct7b5D == 1'b0)
                    ALUControlE = 4'b0110;      //srl
                else
                    ALUControlE = 4'b0111;      //sra
                    end
            3'b110: ALUControlE = 4'b1000;      //or
            3'b111: ALUControlE = 4'b1001;      //and
            default: ALUControlE = 4'bz;
            endcase
        endcase
    end
endmodule
