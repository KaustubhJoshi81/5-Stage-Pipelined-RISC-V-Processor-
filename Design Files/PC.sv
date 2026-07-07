`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:24:41
// Design Name: Fetch Stage (1st)
// Module Name: PC
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is Program Counter [PC] register. The PCNextF depends upoon the type of current instruction.
                
                For R,I,L,S & U-type, PCNextF is PC + 4.
                For Jump or B-type (taken), PCNextF is the target address.
                    The Target address could be (immediate + PC) which is calculated using another adeer 
                    or (immediate + Xx) using ALU.   
                    
                Mux3 will be used to choose one of the above signal.
*/                
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input  logic [31:0] PCNextF,       //Next PC Fetch Stage
    input  logic        clk,
    input  logic        StallF,         //Stalling is Active_low
    input  logic        reset,
    output logic [31:0] PCF             //PC Fetch Stage
    );
    
    always @(posedge clk, posedge reset) begin
    if (reset)
        PCF <= 32'b0;
    else if(~StallF)
        PCF <= PCNextF;
    end
endmodule
