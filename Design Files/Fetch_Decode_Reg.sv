`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 
// Design Name: Datapath
// Module Name: Fetch_Decode_Register
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
// Description: Register seperating Fetch and Decode stages.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fetch_Decode_Reg(    
    //Clock, Enable and Clear Signals
    input  logic        clk,
    input  logic        StallD,
    input  logic        FlushD,
    
    //Datapath Input Signals
    input  logic [31:0] InstrF,     //From Instruction Memory
    input  logic [31:0] PCF,
    input  logic [31:0] PCPlus4F,
    
    //Datapath Output Signals
    output logic [31:0] InstrD,
    output logic [31:0] PCD,
    output logic [31:0] PCPlus4D
);

always_ff @(posedge clk) begin
    if (FlushD) begin
        InstrD   <= 32'b0;
        PCD      <= 32'b0;
        PCPlus4D <= 32'b0;
    end
    else if(~StallD) begin
        InstrD   <= InstrF;
        PCD      <= PCF;
        PCPlus4D <= PCPlus4F;
    end  
end

endmodule