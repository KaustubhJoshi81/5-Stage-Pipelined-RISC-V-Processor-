`timescale 1ns / 1ps
//`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 12:38:24
// Design Name: 
// Module Name: Processor
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


module Processor(
    //Clock & reset
    input  logic clk, reset,
    
    //Input from Instruction & Data Memory
    input  logic [31:0] InstrF,
    input  logic [31:0] ReadDataM,
    
    //Output to Instruction & Data Memory
    output logic [31:0] PCF,
    output logic [2:0]  funct3M,
    output logic        MemWriteM,      //For testbench as well
    output logic [31:0] ALUResultM,     //For testbench as well
    output logic [31:0] WriteDataM,     //For testbench as well
    
    //Final Output
    output logic        Z,OV,CY,N,      //Logic connecting Datapath & Controller
    output logic [31:0] ALUResultW,
    output logic [31:0] ResultW,
    output logic [31:0] WriteDataW,
    output logic [31:0] ALUResultE
    );
    
//Logic connecting Datapath & Controller
logic [31:0] InstrD;

logic        JumpE;        
logic        BranchE;      
logic [2:0]  funct3E;      

logic        RegWriteD;  
logic [2:0]  ResultSrcD; 
logic        MemWriteD;  
logic        JumpD;      
logic        BranchD;    
logic [3:0]  ALUControlD;
logic        ALUSrcD;    
logic [2:0]  ImmSrcD;    
    
logic [1:0]  PCSrcE;    

//Logic connecting Datapath & Hazard Unit
logic [1:0]  ForwardAE;
logic [1:0]  ForwardBE;
logic        StallF;   
logic        StallD;   
logic        FlushD;   
logic        FlushE;   

logic [4:0]  Rs1D;       
logic [4:0]  Rs2D;       
logic [4:0]  Rs1E;       
logic [4:0]  Rs2E;       
logic [4:0]  RdE;        
logic [4:0]  RdM;        
logic [4:0]  RdW;        
logic        ResultSrcE0;
logic        RegWriteM;  
logic        RegWriteW;  

Controller con (InstrD [6:0], InstrD [14:12], InstrD [30],
                JumpE, BranchE, funct3E, Z, OV, CY, N,
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD,    
                PCSrcE
                );

Datapath dp (RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD, PCSrcE,       
             ForwardAE, ForwardBE, StallF, StallD, FlushD, FlushE,   
             InstrF, ReadDataM,
             clk, reset,
             InstrD,
             Z, CY, OV, N, JumpE, BranchE, funct3E,
             Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW, ResultSrcE0, RegWriteM, RegWriteW,  
             PCF, funct3M, MemWriteM, ALUResultM, WriteDataM, 
             ALUResultW, ResultW, WriteDataW, ALUResultE 
             );
             
HazardUnit hu (reset,
               Rs1E, Rs2E, RdM, RdW, RegWriteM, RegWriteW, ForwardAE, ForwardBE,
               ResultSrcE0, Rs1D, Rs2D, RdE, StallF, StallD,     
               PCSrcE, FlushD, FlushE 
               );

//`default_nettype wire
endmodule
