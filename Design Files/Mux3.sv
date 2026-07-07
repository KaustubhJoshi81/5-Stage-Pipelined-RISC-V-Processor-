`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:35:03
// Design Name: Fetch Stage & Execution Stage
// Module Name: Mux3
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is 3:1 Multiplexer. This will be used in:
                1. Fetch Stage for selecting PCNextF signal
                2. Execution Stage for handling data hazards
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux3(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,
    input  logic [1:0]  src,
    output logic [31:0] y
    );
    
    always_comb begin
        case(src)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = 32'b0;
        endcase
    end
endmodule
