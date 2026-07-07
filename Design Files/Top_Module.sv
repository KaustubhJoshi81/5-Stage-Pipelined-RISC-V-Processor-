`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2026 10:44:50
// Design Name: 
// Module Name: Top_Module
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


module Top_Module(
    input  logic        clk,
    input  logic        reset,
    
    output logic        Z,OV,CY,N,
    output logic [31:0] ALUResultW,
    output logic [31:0] ResultW,
    output logic [31:0] WriteDataW,
    output logic [31:0] ALUResultE
 
    );
    
    //Logic connecting Processor to Instruction & Data Memory
    logic [31:0] PCF;
    logic [31:0] InstrF;
    logic [2:0]  funct3M;
    logic [31:0] ReadDataM;
    logic [31:0] WriteDataM;
    logic        MemWriteM;
    logic [31:0] ALUResultM;
    
    Processor cpu (clk, reset,
                   InstrF, ReadDataM,
                   PCF, funct3M, MemWriteM, ALUResultM, WriteDataM,
                   Z,OV,CY,N, ALUResultW, ResultW, WriteDataW, ALUResultE
                   );
                   
    InstrMem im (PCF, InstrF);
                 
    DataMem dm (ALUResultM, WriteDataM, MemWriteM, funct3M, clk,
                ReadDataM
                );
    
endmodule
