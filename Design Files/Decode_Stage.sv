`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 12:17:16
// Design Name:  Datapath
// Module Name: Decode_Stage
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is 2nd stage of the pipeline. This module consists of Register file &
                Sign extension unit & Decoded_Execute_Reg (DEReg). 
                
                The DEReg takes input from both Fetch stage and Instruction Memory and the output
                is sent to Register file, sign extension unit and some signals are sent to next stage
                as it is. 
                Some signals (Rs1D, Rs2D) are output signals given to Hazard unit.
                In this Stage, ImmSrcD control signal is taken from controller.
                Rest of the signals are recieved in next stage
                
                Both Sign extension unit and register file take some part of Instruction as input and give output
                accordingly. The sign extension unit also takes ImmSrc signal as input from 
                controller. The register file also takes WriteEnable (RegWriteW) and clock as 
                input. The RegWriteW signal is taken from WriteBack stage.
                
                The outputs RD1D, RD2D & ImmExtD are later on sent to ALU. 
                
                This stage also has Rs1D, Rs2D, RdD register address as outputs which are used by 
                Hazard unit. The Rs1E & Rs2E are also used by Hazard Unit as input.
                
                The PCD signal is passed through this stage without applying any logic to 
                the signal, as it will be used for calculating BTA/JTA (Brach/Jump target Address)
                The PCPlus4D signal is alo passed through this stage without applying any logic
                to the signal.  
*/ 
// Dependencies: Register file, Sign Extension Unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decode_Stage(
    //Sign Extension Control Signal and Clock
    input  logic [2:0]  ImmSrcD,
    input  logic        clk,
        
    //Input signals from Hazard Unit
    input  logic        StallD,
    input  logic        FlushD,
    
    //Datapath signals from Fetch Stage and Instruction memory
    input  logic [31:0] InstrF,
    input  logic [31:0] PCF,
    input  logic [31:0] PCPlus4F,
    
    //Address, Data & Control signal for Write-Back Stage
    input  logic [4:0]  RdW,                
    input  logic [31:0] ResultW,            
    input  logic        RegWriteW,          
    
    //Output to Controller
    output logic [31:0] InstrD,
    
    output logic [2:0]  funct3D,
    
    //Datapath output signals
    output logic [31:0] RD1D,
    output logic [31:0] RD2D,
    output logic [31:0] PCD,
    output logic [4:0]  Rs1D,
    output logic [4:0]  Rs2D,
    output logic [4:0]  RdD,
    output logic [31:0] ImmExtD,
    output logic [31:0] PCPlus4D
    );

assign funct3D = InstrD [14:12];

assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD  = InstrD[11:7];

Fetch_Decode_Reg FDReg (clk, StallD, FlushD,
                        InstrF, PCF, PCPlus4F,
                        InstrD, PCD, PCPlus4D);

RegFile RegisterFile (Rs1D, Rs2D, RdW, ResultW, RegWriteW, clk, RD1D, RD2D);

SignExt ExtUnit (ImmSrcD, InstrD [31:7], ImmExtD);
     
endmodule
