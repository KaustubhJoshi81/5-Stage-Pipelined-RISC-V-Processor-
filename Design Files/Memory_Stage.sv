`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 14:50:08
// Design Name: Processor
// Module Name: Memory_Stage
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is 4th Stage of the pipeline. This stage consists of only Execute_Memory_Register.
                As the datamemory is seperated from datapath, ALUResultM, WriteDataM are output signals
                of this module as well as Processor module and Top_module. 
                
                The Stage requires ALUResultM, WriteDataM as input signals to write/read data.             
                
                RdM, PCPlus4M, ImmExtM are passed through the stage as it is. 
                The RdM & RegWriteM signals are input to the hazard unit for forwarding.
                
                The ALUResultM also acts as output signal, as this signal will be WriteBack stage.
                
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Memory_Stage(
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
    input  logic [31:0] PCPlus4E,
    input  logic [31:0] ImmExtE,        //lui
    
    //Clock signal
    input  logic        clk,
    
    //Control Output Signals 
    output logic        RegWriteM,
    output logic [2:0]  ResultSrcM,
    output logic        MemWriteM,
    output logic [2:0]  funct3M,
    
    //Datapath Output signals
    output logic [31:0] ALUResultM,
    output logic [31:0] WriteDataM,
    output logic [31:0] PCTargetM,      //auipc
    output logic [4:0]  RdM,
    output logic [31:0] PCPlus4M,
    output logic [31:0] ImmExtM        //lui
    );
    
Execute_Memory_Reg EMReg (RegWriteE, ResultSrcE, MemWriteE, funct3E, 
                          ALUResultE, WriteDataE, PCTargetE, RdE, ImmExtE, PCPlus4E, 
                          clk,
                          RegWriteM, ResultSrcM, MemWriteM, funct3M,
                          ALUResultM, WriteDataM, PCTargetM, RdM, ImmExtM, PCPlus4M    
                          );
    
endmodule
