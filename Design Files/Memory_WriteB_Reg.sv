`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 10:28:10
// Design Name: 
// Module Name: Memory_WriteB_Reg
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


module Memory_WriteB_Reg(

    //Control Input Signals
    input  logic        RegWriteM,
    input  logic [2:0]  ResultSrcM,
        
    //Clock signal
    input  logic        clk,
    
    //Datapath Input Signals
    input  logic [31:0] ALUResultM,
    input  logic [31:0] ReadDataM,
    input  logic [31:0] WriteDataM,
    input  logic [31:0] PCTargetM,      //auipc
    input  logic [4:0]  RdM,
    input  logic [31:0] ImmExtM,        //lui
    input  logic [31:0] PCPlus4M,
    
    
    //Control Output Signals
    output  logic        RegWriteW,
    output  logic [2:0]  ResultSrcW,
    
    //Datapath Output Signals
    output  logic [31:0] ALUResultW,
    output  logic [31:0] ReadDataW,
    output  logic [31:0] WriteDataW,
    output  logic [31:0] PCTargetW,
    output  logic [4:0]  RdW,
    output  logic [31:0] ImmExtW,
    output  logic [31:0] PCPlus4W
    );
    
always_ff @(posedge clk) begin

    RegWriteW   <=  RegWriteM; 
    ResultSrcW  <=  ResultSrcM;

    ALUResultW  <=  ALUResultM;
    ReadDataW   <=  ReadDataM; 
    WriteDataW  <=  WriteDataM;
    PCTargetW   <=  PCTargetM;
    RdW         <=  RdM;       
    ImmExtW     <=  ImmExtM;
    PCPlus4W    <=  PCPlus4M;
      
end
    
endmodule
