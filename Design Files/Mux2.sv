`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:35:03
// Design Name: Execution Stage
// Module Name: Mux2
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
// Description: This is 2:1 Multiplexer. This is used to choose SrcBE signal.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux2(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        src,
    output logic [31:0] y
    );
    
    assign y = src ? b:a; 
    
endmodule
