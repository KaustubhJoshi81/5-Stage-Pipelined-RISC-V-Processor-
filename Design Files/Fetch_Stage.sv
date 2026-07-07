`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 15:23:20
// Design Name: Datapath
// Module Name: Fetch_Stage
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is first stage of the pipeline. This module consits of 2:1 PC Mux,
                Program Counter register and Adder for PCPlus4F signal. The Instruction Memory 
                (& Data Memory) are not a part of the datapath, hence the decode stage has to 
                take inputs from both this stage as well as from Instruction Memory seperately.
                
                Input signal to PCMux is PCPLus4F & ALUResultE, which taken from Execution Stage.
                It also takes input from the controller to control the PCMux and ~Enable (StallF) 
                signal from Hazard Unit during Control hazard.
                
                The module has 3 outputs: Instruction, PC and PCPlus4.
                instruction is sent to RegisterFile for decoding, whereas PC & PCPlus4 aren't used
                by Decode Stage. PC is used in Execution Stage for jal, jalr & B-type instruction.
                PCPlus4 signal is used in WriteBack Stage for jal, jalr
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fetch_Stage(
    //Control Signal for PCMux
    input  logic [1:0]  PCSrcE,
    
    //Control signal for PC Register
    input  logic        StallF,
    input  logic        clk,
    input  logic        reset,
    
    //Datapath input signal
    input  logic [31:0] PCTargetE,          //BTA, jal
    input  logic [31:0] ALUResultE,         //Jalr
    
    //Datapath Output Signals
    output logic [31:0] PCF,
    output logic [31:0] PCPlus4F
    );

logic [31:0] PCNextF;

Mux3 PCNextFMux(PCPlus4F, PCTargetE, ALUResultE, PCSrcE, PCNextF);
PC ProgCount (PCNextF, clk, StallF, reset, PCF);
Adder PCPlus4 (PCF, 32'h04, PCPlus4F);

endmodule