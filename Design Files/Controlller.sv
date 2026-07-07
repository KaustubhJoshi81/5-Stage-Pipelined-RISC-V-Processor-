`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 10:46:19
// Design Name: 
// Module Name: Controlller
// Project Name: 
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


module Controller(
    //Main Decoder inputs and outputs
    input  logic [6:0] OpD,          
    input  logic [2:0] funct3D,
    input  logic       funct7b5D,
    
    //Input Signals from Datapath for calculating PCSrcE
    input  logic        JumpE,
    input  logic        BranchE,
    input  logic [2:0]  funct3E,
    input  logic        Z, OV, CY, N,
    
    //Output signals to Decode Stage of Datapath
    output logic        RegWriteD,
    output logic [2:0]  ResultSrcD,
    output logic        MemWriteD,
    output logic        JumpD,
    output logic        BranchD,
    output logic [3:0]  ALUControlD,
    output logic        ALUSrcD,
    output logic [2:0]  ImmSrcD,
    
    //Output signals to PCMux during Execution Stage of Datapath
    output logic [1:0]  PCSrcE
    );

logic [1:0] ALUOpD;

MainDecoder MainDec(OpD, funct3D, 
                    RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUOpD, ALUSrcD, ImmSrcD);

ALUDecoder ALUDec(ALUOpD, funct3D, funct7b5D, 
                  ALUControlD); 

//PCSrcE Logic 
always_comb begin
    if (JumpE & OpD == 7'd103) begin
        PCSrcE = 2'b10;                     //jalr
    end
    else begin
        case (funct3E) 
            3'b000: PCSrcE =  (Z & BranchE)      | JumpE ? 2'b01: 2'b00;       //beq
            3'b001: PCSrcE = ~Z & BranchE        | JumpE ? 2'b01: 2'b00;       //bne
            3'b100: PCSrcE =  (OV ^ N) & BranchE | JumpE ? 2'b01: 2'b00;       //blt
            3'b101: PCSrcE = ~(OV ^ N) & BranchE | JumpE ? 2'b01: 2'b00;       //bge
            3'b110: PCSrcE = ~CY & BranchE       | JumpE ? 2'b01: 2'b00;       //bltu -> Branch if borrow
            3'b111: PCSrcE =  CY & BranchE       | JumpE ? 2'b01: 2'b00;       //bgeu -> Branch if no borrow
            default: PCSrcE = 2'b00;
        endcase
    end
end

endmodule
