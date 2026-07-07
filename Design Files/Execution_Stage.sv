`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 12:36:24
// Design Name: Datapath
// Module Name: Execution_Stage
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is 3rd Stage of the pipeline. This module consists of Decode_Execution_Reg (DEReg), 
                2 3:1 Mux, 1 2:1 Mux, ALU and Adder. 
                
                The DEReg takes input from decode stage and from controller. The output are sent to 
                the mulitplexer, adder, next stage (Memory stage) register, and few signals
                (BranchE, JumpE) are sent back to controller to calculate PCSrcE signal. 
                
                The 3:1 multiplexers are used for instruction forwarding, 
                whereas 2:1 Mux is used to choose between ImmExt and RD2E depending upon type 
                of instruction. The adder is used to calculate JTA and BTA 
                (Jump & Branch target address).
                
                SrcAE, SrcBE, PCE & ImmExtE signals are input signals which are used by ALU & Adder.
                ALUControlE & ALUSrc are control signals given by controller.
                The ALU unit is the module executing the the instruction. The output of the unit
                are ALUResultE and flags (Z,CY,OV). These flags are sent to the controller
                to calculate PCSrcE signal.
                
                There are also additional input signals necessary for instruction forwarding:
                ALUResultM & ResultW
                The Mux3 units are controlled by Hazard Unit using the signals ForwardAE and
                ForwardBE.
                In this stage, the hazard unit takes Rs1E, Rs2e, RdE are input signals from the
                datapath and ResultSrcE0 from the controller.
                
                In this stage, RdE,PCPlus4E signals are passed though as it is. The Rd signal
                will used during Write-Back stage and as input to Hazard unit to detect data 
                hazards. The PCPlus4 signal is also used for Write-Back Stage to store 
                current PC for jal & jalr instructions. 
                
                The ImmExtE signal is also passed through as it is used in WriteBack stage 
                for lui (load upper immediate) instruction.
                
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Execution_Stage(
    
    //Input Control Signals
    input logic        RegWriteD,
    input logic [2:0]  ResultSrcD,
    input logic        MemWriteD,
    input logic        JumpD,
    input logic        BranchD,
    input logic [3:0]  ALUControlD,
    input logic        ALUSrcD,
    input logic [2:0]  funct3D,
    
    //Datapath input signals
    input  logic [31:0] RD1D,
    input  logic [31:0] RD2D,
    input  logic [31:0] PCD,
    input  logic [4:0]  Rs1D,
    input  logic [4:0]  Rs2D,
    input  logic [4:0]  RdD,
    input  logic [31:0] ImmExtD,
    input  logic [31:0] PCPlus4D,
    
    //Control Signals for Hazards
    input  logic  [1:0] ForwardAE, 
    input  logic  [1:0] ForwardBE, 
    input  logic        FlushE,
    
    //Clock signal
    input  logic        clk,
         
    //Inputs for Forwarding from Memory and Write-Back Stage
    input  logic [31:0] ALUResultM,
    input  logic [31:0] ResultW,
     
    //Output Control signals to next stage register
    output logic        RegWriteE,
    output logic [2:0]  ResultSrcE,
    output logic        MemWriteE,
    
    //Output signals sent back to Controller for calculating PCSrcE
    output logic        JumpE,
    output logic        BranchE,
    output logic [2:0]  funct3E,
    output logic        Z,OV,CY,N,   
    
    //Output signals sent to Hazard Unit
    output logic        ResultSrcE0,
    output logic [4:0]  Rs1E,
    output logic [4:0]  Rs2E,
        
    //Output Datapath Signals of the Execute Stage
    output logic [31:0] ALUResultE,     //Top_Module Output
    output logic [31:0] WriteDataE,         
    output logic [31:0] PCTargetE,      //Jump instructions and auipc
    output logic [4:0]  RdE,            //Also sent to Hazard Unit
    output logic [31:0] ImmExtE,        //lui
    output logic [31:0] PCPlus4E                
    );

//Control Signals conncting DEReg to ALU and 2:1 Mux
logic [3:0] ALUControlE;
logic       ALUSrcE;

//Datapath signals connecting DEReg to 3:1 Mux, Adder
logic [31:0] RD1E;
logic [31:0] RD2E;
logic [31:0] PCE;

Decode_Execute_Reg DEReg (RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, funct3D,    
                          RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D,
                          clk, FlushE,
                          RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, funct3E,    
                          RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E
                          );

logic [31:0] SrcAE;
logic [31:0] SrcBE;

Mux3 FwdAEmux(RD1E, ResultW, ALUResultM , ForwardAE, SrcAE);
Mux3 FwdBEmux(RD2E, ResultW, ALUResultM , ForwardBE, WriteDataE);
Mux2 ALUmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);

Adder PCTargetAdd(PCE, ImmExtE, PCTargetE);
ALU ALUunit(SrcAE, SrcBE, ALUControlE, ALUResultE, Z, OV, CY, N);

assign ResultSrcE0 = ResultSrcE[0];

endmodule
