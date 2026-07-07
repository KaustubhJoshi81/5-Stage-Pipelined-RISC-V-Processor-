`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:24:41
// Design Name: 
// Module Name: InstrMem
// Project Name: 5-Stage Pipeline RISC-V Processor
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


module InstrMem(
    input  logic [31:0] PCF,               //Program Counter Fetch Stage
    output logic [31:0] InstrF            //Output Intruction Fetch Stage
    );
    
    logic [31:0] Instrmem [200:0];
    
    initial begin
        $readmemh ("riscvtext.mem", Instrmem);
    end
    
    assign InstrF = Instrmem[PCF[31:2]];         //Word-Aligned

endmodule
