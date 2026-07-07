`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:26:25
// Design Name: Decode Stage (2nd)
// Module Name: SignExt
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This functional unit is Sign-Extension unit. This module sign extends the immediated encoded in the instruction.
                Refer to RISC-V RV32I ISA encoding during Verification.
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SignExt(
    //Control signal
    input  logic [2:0]  ImmSrcD,
    
    //datapath signals
    input  logic [31:7] InstrD,
    output logic [31:0] ImmExtD
    );
    
    always_comb begin
        case(ImmSrcD) 
            3'b000: ImmExtD = {{20{InstrD[31]}}, InstrD[31:20]};                                    //I-type Instr
            3'b001: ImmExtD = {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]};                      //S-type Instr
            3'b010: ImmExtD = {{20{InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0};     //B-type Instr
            3'b011: ImmExtD = {InstrD[31:12], 12'b0};                                               //U-type Instr 
            3'b100: ImmExtD = {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0};   //J-type Instr
            default: ImmExtD = 32'bx;
        endcase
    end
endmodule
