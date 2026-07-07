`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 12:42:58
// Design Name: 
// Module Name: Datapath
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


module Datapath(
    //Control Signals
    input  logic        RegWriteD,
    input  logic [2:0]  ResultSrcD,
    input  logic        MemWriteD,
    input  logic        JumpD,
    input  logic        BranchD,
    input  logic [3:0]  ALUControlD,
    input  logic        ALUSrcD,
    input  logic [2:0]  ImmSrcD,
//    input  logic [2:0]  funct3D,
    input  logic [1:0]  PCSrcE,   
    
    //Hazard Unit Signals
    input  logic [1:0]  ForwardAE, 
    input  logic [1:0]  ForwardBE, 
    input  logic        StallF,
    input  logic        StallD,
    input  logic        FlushD,
    input  logic        FlushE,
    
    //Instruction & Data Memory Input Signals
    input  logic [31:0] InstrF,
    input  logic [31:0] ReadDataM,
    
    //Clock & reset signal
    input  logic        clk,
    input  logic        reset,
    
    //Output to Controller
    output logic [31:0] InstrD,
    
    //Output signals to Controller for caluclating PCSrcE
    output logic        Z,              //Also act as Final output
    output logic        CY,             //Also act as Final output
    output logic        OV,             //Also act as Final output
    output logic        N,              //Also act as Final output
    output logic        JumpE,          
    output logic        BranchE,        
    output logic [2:0]  funct3E,
    
    //Output Signals to Hazard Unit
    output logic [4:0]  Rs1D,
    output logic [4:0]  Rs2D,
    output logic [4:0]  Rs1E,
    output logic [4:0]  Rs2E,
    output logic [4:0]  RdE,
    output logic [4:0]  RdM,
    output logic [4:0]  RdW,
    output logic        ResultSrcE0,
    output logic        RegWriteM,
    output logic        RegWriteW,
    
    //Output Signals to Instruction & Data Memory
    output logic [31:0] PCF,
    output logic [2:0]  funct3M,
    output logic        MemWriteM,
    output logic [31:0] ALUResultM,
    output logic [31:0] WriteDataM,
    
    //Final output signals
    output logic [31:0] ALUResultW,
    output logic [31:0] ResultW,
    output logic [31:0] WriteDataW,
    output logic [31:0] ALUResultE
    );

//-----------------------------------------------------------------------------------------------------------//

//logic connecting Execution_Stage to Fetch_Stage
logic [31:0] PCTargetE;

//logic connecting Fetch_Stage to Decode_Stage
logic [31:0] PCPlus4F;

Fetch_Stage FS (PCSrcE, 
                StallF, clk, reset,
                PCTargetE, ALUResultE,                
                PCF, PCPlus4F 
                );

//-----------------------------------------------------------------------------------------------------------//

//logic connecting WriteBack_Stage to Decode_Stage are already declared as output -> RdW, ResultW and RegWriteM

//logic connecting Decode_Stage to Execution_Stage
//Signals already declared as output: Rs1D, Rs2D -> connecting Datapath & Hazard Unit
logic [2:0]  funct3D;

logic [31:0] RD1D;
logic [31:0] RD2D;
logic [31:0] PCD;
logic [4:0]  RdD;
logic [31:0] ImmExtD;
logic [31:0] PCPlus4D;

Decode_Stage DS (ImmSrcD, clk,
                 StallD, FlushD,
                 InstrF, PCF, PCPlus4F,
                 RdW, ResultW, RegWriteW,
                 InstrD,
                 funct3D,
                 RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D
                 );

//-----------------------------------------------------------------------------------------------------------//

//logic connecting Memory_Stage and WriteBack_Stage to Execution_Stage for Hazard prevention
//Already declared as output ports -> ALUResultM, ResultW

//logic connecting Execute_Stage to Memory_Stage
//Already declared as output port -> ALUResultE, RdE, funct3E
logic        RegWriteE;
logic [2:0]  ResultSrcE;
logic        MemWriteE;

logic [31:0] WriteDataE;
logic [31:0] ImmExtE;
logic [31:0] PCPlus4E;

Execution_Stage ES (RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, funct3D,    
                    RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D,
                    ForwardAE, ForwardBE, FlushE,   
                    clk,
                    ALUResultM, ResultW,   
                    RegWriteE, ResultSrcE, MemWriteE, 
                    JumpE, BranchE, funct3E, Z,OV,CY,N,
                    ResultSrcE0, Rs1E, Rs2E,
                    ALUResultE, WriteDataE, PCTargetE, RdE, ImmExtE, PCPlus4E   
                    );

//------------------------------------------------------------------------------------------------------------//

//logic connecting Memory_Stage to WriteBack_Stage
//Somoe Signals are already declared as output -> RegWriteM, ALUResultM, WriteDataM, RdM
logic [2:0]  ResultSrcM;
logic [31:0] PCTargetM;
logic [31:0] ImmExtM;
logic [31:0] PCPlus4M;

Memory_Stage MS (RegWriteE, ResultSrcE, MemWriteE, funct3E, 
                 ALUResultE, WriteDataE, PCTargetE, RdE, PCPlus4E, ImmExtE,   
                 clk,
                 RegWriteM, ResultSrcM, MemWriteM, funct3M,   
                 ALUResultM, WriteDataM, PCTargetM, RdM, PCPlus4M, ImmExtM    
                 );

//------------------------------------------------------------------------------------------------------------//

WriteBack_Stage WBS (RegWriteM, ResultSrcM,
                     clk,
                     ALUResultM, ReadDataM, WriteDataM, PCTargetM, RdM, PCPlus4M, ImmExtM,   
                     RegWriteW,
                     ALUResultW, ResultW, WriteDataW, RdW        
                     );

endmodule
