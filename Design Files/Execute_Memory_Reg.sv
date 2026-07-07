`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 
// Design Name: Processor
// Module Name: Fetch_Decode_Register
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
// Description: Register seperating Execution and Memory stages.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Execute_Memory_Reg(
    //Control Input Signals
    input  logic        RegWriteE,
    input  logic [2:0]  ResultSrcE,
    input  logic        MemWriteE,
    input  logic [2:0]  funct3E,
    
    //Datapath Input Signals
    input  logic [31:0] ALUResultE,
    input  logic [31:0] WriteDataE,
    input  logic [31:0] PCTargetE,      //auipc
    input  logic [4:0]  RdE,
    input  logic [31:0] ImmExtE,        //lui
    input  logic [31:0] PCPlus4E,
    
    //Clock signal
    input  logic        clk,
    
    //Control Output Signals
    output logic        RegWriteM,
    output logic [2:0]  ResultSrcM,
    output logic        MemWriteM,
    output logic [2:0]  funct3M,
    
    //Datapath output Signals
    output logic [31:0] ALUResultM,
    output logic [31:0] WriteDataM,
    output logic [31:0] PCTargetM,      //auipc
    output logic [4:0]  RdM,
    output logic [31:0] ImmExtM,        //lui
    output logic [31:0] PCPlus4M
    
);

always_ff @(posedge clk) begin
      
      RegWriteM   <=   RegWriteE; 
      ResultSrcM  <=   ResultSrcE;
      MemWriteM   <=   MemWriteE; 
      funct3M     <=   funct3E;
     
      ALUResultM  <=   ALUResultE;
      WriteDataM  <=   WriteDataE;
      PCTargetM   <=   PCTargetE;
      RdM         <=   RdE;       
      ImmExtM     <=   ImmExtE;
      PCPlus4M    <=   PCPlus4E;  
 
end

endmodule