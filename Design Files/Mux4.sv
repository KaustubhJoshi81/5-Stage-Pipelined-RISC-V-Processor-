`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 15:55:22
// Design Name: Write-Back Stage (5th)
// Module Name: Mux4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This functional unit is a 4:1 Multiplexer which will be used to select final signal for Write-Back Stage
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux5(
    input  logic [31:0] ALUResultW,
    input  logic [31:0] ReadDataW,
    input  logic [31:0] PCPlus4W,
    input  logic [31:0] PCTargetW,
    input  logic [31:0] ImmExtW,
    input  logic [2:0]  ResultSrcW,
    output logic [31:0] ResultW
    );
    
    always_comb begin
        case(ResultSrcW)
        3'b000: ResultW = ALUResultW;         //R-type, I-type except load and jalr
        3'b001: ResultW = ReadDataW;          //load instructions
        3'b010: ResultW = PCPlus4W;           //jal & jalr
        3'b011: ResultW = PCTargetW;          //auipc instruction
        3'b101: ResultW = ImmExtW;            //lui instruction     
        default: ResultW  = 32'b0;
        endcase
    end
endmodule
