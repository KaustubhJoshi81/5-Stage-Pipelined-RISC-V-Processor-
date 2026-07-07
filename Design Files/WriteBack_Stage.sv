`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 15:00:19
// Design Name: Processor
// Module Name: WriteBack_Stage
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This is the 5th (& last) stage of the pipeline. This stage consists of only a 4:1 
                multiplexer. 
                ALUResultW, ReadDataW, PCPlus4W and PCTargetW (for auipc instr) are the input
                signals and the output is ResultW which is sent to the Register File.
                The mux is controlled used ResultSrcW signal provided by controller.
                
                The RdW is passed through this stage to the register file (instance located in 
                Decode stage). 
                
                The RdW and RegWriteW signals are provided as input to the Hazard unit 
                to resolve data hazards using forwarding.
                
                WriteDataM/W signals are also included for testbench purposes to check the result of the 
                instructions.
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WriteBack_Stage(
    //Control Input signals
    input  logic        RegWriteM,
    input  logic [2:0]  ResultSrcM,

    //Clock Signal
    input  logic        clk,
        
    //Datapath Input Signals
    input  logic [31:0] ALUResultM,
    input  logic [31:0] ReadDataM,
    input  logic [31:0] WriteDataM,
    input  logic [31:0] PCTargetM,      //auipc
    input  logic [4:0]  RdM,
    input  logic [31:0] PCPlus4M,
    input  logic [31:0] ImmExtM,        //lui
    
    //Control output Signal [Used by Register File]
    output logic        RegWriteW,
    
    //Datapath Output Signal 
    output logic [31:0] ALUResultW,
    output logic [31:0] ResultW,        //[Used by Register File]       //Also Top_MOdule Final Output
    output logic [31:0] WriteDataW,     //[Used by Register File]
    output logic [4:0]  RdW             //[Used by Register File]
    );
    
    //Signals connecting MWReg and Mux5
    logic [2:0]  ResultSrcW;
    logic [31:0] ReadDataW;  
    logic [31:0] PCTargetW;
    logic [31:0] ImmExtW;
    logic [31:0] PCPlus4W;
    
Memory_WriteB_Reg MWReg(RegWriteM, ResultSrcM,
                        clk,
                        ALUResultM, ReadDataM, WriteDataM, PCTargetM, RdM, ImmExtM, PCPlus4M,       
                        RegWriteW, ResultSrcW,
                        ALUResultW, ReadDataW, WriteDataW, PCTargetW, RdW, ImmExtW, PCPlus4W 
                        );

Mux5 ResultMux(ALUResultW, ReadDataW, PCPlus4W, PCTargetW, ImmExtW, ResultSrcW, ResultW);
    
endmodule
