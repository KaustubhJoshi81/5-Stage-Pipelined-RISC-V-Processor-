`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 15:19:07
// Design Name: Controller
// Module Name: MainDecoder
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: 


********This module doesn't include PCSrcE, That will be created in Processor module (execution stage module) 
        as Execution stage signals are required for the PCSrcE logic*****************************************
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MainDecoder(
    input  logic [6:0] Op,
    input  logic [2:0] funct3D,
    
    output logic       RegWriteD,
    output logic [2:0] ResultSrcD,
    output logic       MemWriteD,
    output logic       JumpD,
    output logic       BranchD,
    output logic [1:0] ALUOp,
    output logic       ALUSrcD,
    output logic [2:0] ImmSrcD
    );
    
    logic [12:0] controls;
    
    always_comb begin
        case(Op) 
        
//----------------------------------------------I-Type Instructions (except jalr)-----------------------------------------------//
        
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD 
            7'd3:   controls = 13'b1_____001________0_________0_____0_______00____1_______000;         //Load instructions
                                                                                                       // rd = [rs1 + ImmExt]                        
                                                                                                       //Need RegWrite Enable, ImmSrc = 000, Select ImmExt signal, 
                                                                                                       //Addition in ALU, Select ALU result as final result.                                                                                               
            7'd19: begin
                   if (funct3D == 3'b0)
                                 //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD 
                        controls = 13'b1_____000________0_________0_____0_______00____1_______000;     //addi
                   else
                                 //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD 
                        controls = 13'b1_____000________0_________0_____0_______10____1_______000;     //Rest of I-type instructions. 
                   end                                                                                 // rd = rs1 _? ImmExt
                                                                                                       //Need RegWrite, ImmSrc = 000, Select Imm signal [1],
                                                                                                       //ALUDecoder must use go into default case,
                                                                                                       //select ALUresult as final result [000]
                
//--------------------------------------Add Upper Immediate to PC Instruction--------------------------------------------------//                             
                             
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD 
            7'd23:  controls = 13'b1_____011________0_________0_____0_______00____0_______011;         //auipc instruction.
                                                                                                       // rd = PC + ImmExt
                                                                                                       //Need RegWrite, ImmSrc = 011, 
                                                                                                       //ALU is not used hence ALUOp = zz,
                                                                                                       //same for 2:1 mux. The final result 
                                                                                                       //taken from PCTarget Adder [hence ResulSrc=11].
                             
//----------------------------------------------s-Type Instructions------------------------------------------------------------//                             
                             
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD         
            7'd35:  controls = 13'b0_____000________1_________0_____0_______00____1_______001;         //Store instructions                                                           
                                                                                                       // [rs1 + Immext] = rs2
                                                                                                       //Need MemWrite, select ImmExt signal & ALUOp =00 
                                                                                                       //to calculate address.
                                                                                                       //ResultSrc is not used value doesn't matter[zz here].
                             
//-----------------------------------------------R-Type Instructions-----------------------------------------------------------//                             
                             
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD         
            7'd51:  controls = 13'b1_____000________0_________0_____0_______10____0_______zzz;         //R-type Instructions  
                                                                                                       // rd = rs1 _? rs2                                                                                                               
                                                                                                       //Same as other I-type instructions but select RD2E [ALUSrc = 0]
                             
//-----------------------------------------------Load Upper Immediate Instruction----------------------------------------------//
                             
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD
            7'd55:  controls = 13'b1_____100________0_________0_____0_______00____0_______011;         //lui instruction
                                                                                                       //same as auipc instruction, except ImmExtW signal is choosen
                                                                                                       //as the final result.
//-----------------------------------------------B-type Instructions-----------------------------------------------------------//                             
                             
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD
            7'd99:  controls = 13'b0_____000________0_________0_____1_______01____0_______010;         //B-type Instructions
            
//-----------------------------------------------Jump Instructions-----------------------------------------------------------//                             
                             
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD
            7'd103: controls = 13'b1_____010________0_________1_____0_______00____0_______100;         //jalr
                                                                                                       //PC = rs1 + ImmExt, rd = PC+4 
                                                                                                       
                             //RegWriteD_ResultSrcD_MemWriteD_JumpD_BranchD_ALUOp_ALUSrcD_ImmSrcD
            7'd111: controls = 13'b1_____010________0_________1_____0_______00____0_______100;         //jal
                                                                                                       //PC = JTA = PC+ImmExt, rd = PC+4
                                                                                                       //same control signals as jalr except for PCSrc.                                                                                                                           
        default:   controls = 13'b0;
        endcase
    end
    
    assign RegWriteD  = controls[12];
    assign ResultSrcD = controls[11:9];
    assign MemWriteD  = controls[8];
    assign JumpD      = controls[7];
    assign BranchD    = controls[6];
    assign ALUOp      = controls[5:4];
    assign ALUSrcD    = controls[3];
    assign ImmSrcD    = controls[2:0];
    
endmodule
