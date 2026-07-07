`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kaustubh Joshi
// 
// Create Date: 29.05.2026 10:24:41
// Design Name: Memory Stage (4th)
// Module Name: DataMem
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This module will be used to store data. Always_comb is used for load instructions 
//              and for store instructions, always @(posedge CLK) is used as the data is stored at
                positive clockedge. 
                Other than WriteEnable (WE), funct3 from the instruction is also used to know which 
                type of load/store instruction needs to be executed. 
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMem(
    input  logic [31:0] ALUResultM,         //Address Memory Stage
    input  logic [31:0] WriteDataM,         //WriteData Memory Stage
    input  logic        WE,                 //Write Enable Memory Stage
    input  logic [2:0]  funct3M,            //Control signal for Load/Store instructions Memory Stage
    input  logic        clk,                
    output logic [31:0] ReadDataM           //ReadData Memory Stage
    );
    
    logic [31:0] mem [100:0];
    
    always_comb begin 
        case(funct3M)
            3'b000: ReadDataM  = {{24{mem[ALUResultM [31:2]][7]}}, mem[ALUResultM [31:2]][7:0]};        //lb
            3'b001: ReadDataM  = {{16{mem[ALUResultM [31:2]][15]}}, mem[ALUResultM [31:2]][15:0]};      //lh
            3'b010: ReadDataM  = mem[ALUResultM [31:2]];                                               //lw
            3'b100: ReadDataM  = {{24'b0}, mem[ALUResultM [31:2]][7:0]};                               //lbu
            3'b101: ReadDataM  = {{16'b0}, mem[ALUResultM [31:2]][15:0]};                              //lhu
        default:    ReadDataM  = 32'b0;
        endcase
    end
    
    always @(posedge clk) begin
        if(WE) begin
            case(funct3M)
                3'b000: mem[ALUResultM [31:2]][7:0]  <= WriteDataM[7:0];                             //sb
                3'b001: mem[ALUResultM [31:2]][15:0] <= WriteDataM[15:0];                            //sh
                3'b010: mem[ALUResultM [31:2]]       <= WriteDataM;                                  //sw
            default:    mem[ALUResultM[31:2]]        <= 32'b0;
            endcase
        end
    end
    
endmodule
