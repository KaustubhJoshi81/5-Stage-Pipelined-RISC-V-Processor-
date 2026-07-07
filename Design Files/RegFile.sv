`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:24:41
// Design Name: Decode Stage (2nd) and Write-back Stage (5th)
// Module Name: RegFile 
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This functional unit is the Register file. It has 32 registers, where two registers can be read at a time,
                and one register can be writen when WriteEnable is high & negative edge of clock during Write-Back Stage. 
                The value of register 0 (x0) is hardcoded to zero and the value of this register shouldn't be changed, 
                even during verification.
*/              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegFile 
    (
    input  logic [4:0]  A1D,        //Address 1 Decode stage
    input  logic [4:0]  A2D,        //Address 2 Decode stage
    input  logic [4:0]  A3D,        //Address 3 Decode stage
    input  logic [31:0] WD3D,       //WriteData Decode stage
    input  logic        WE3W,       //Write Enable WriteBack Stage
    input  logic        clk,
    output logic [31:0] RD1D,       //ReadData 1 Decode stage
    output logic [31:0] RD2D        //ReadData 2 Decode stage
    );
    
    logic [31:0] ram [31:0];        //32 registers
    
    always @(negedge clk) begin
        if(WE3W & A3D!=0)
            ram[A3D] <= WD3D;        //Write back [Write back (5th) Stage]
            
        ram[0] <= 32'b0;
    end
    
    assign RD1D = ram[A1D];          //Reading reg1  [Decode(2nd) Stage]
    assign RD2D = ram[A2D];          //Reading reg2  [Decode(2nd) Stage]
    
endmodule
