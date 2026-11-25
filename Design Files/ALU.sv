`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 10:24:41
// Design Name: Execution_Stage
// Module Name: ALU
// Project Name: 5-Stage Pipeline RISC-V Processor
// Target Devices: 
// Tool Versions: 
/* Description: This module is responsible for executing the decoded instructions.
                It has two inputs and executes any one of the arithmetic or logical 
                instruction according to the ALUCOntrolE signal given by controller.
                
                Along with the ALUResultE output signal, the ALU also has Flags which are
                sent to the controller logic to calculate PCSrcE signal for B-type instruction. 
                The PCSrcE signal is also sent to Hazard Unit to resolve Control hazards.
                
                Z (Zero flag):      It is set when the result is zero. This is used for beq, bne
                
                OV (Overflow flag): It is set when there is carry from 30th bit into 31st bit during 
                                    addition or borrow from 31st bit into 30th bit during subtraction.
                                    This flag is used to detect errors in signed arthmetic operations                                    
                                    
                                    4 cases:
                                    A[31]   B[31]   Result[31]  MSB Expected  
                                    1       1       0           1           [-ve + (-ve) should result -ve]
                                    0       0       1           0           [+ve + (+ve) should result +ve]
                                    
                                    0       1       1           0           [+ve - (-ve) should result +ve] 
                                    1       0       0           1           [-ve - (+ve) should result -ve] 

                CY (Carry flag):    It is set when there is carry from or into 31st bit. This flag is used 
                                    to detect errors in unisgned arithmetic operations.
                                    
                                    Rules: 1] The carry flag is set if the addition of two numbers causes 
                                              a carry out of the most significant (leftmost) bits added.   
                                           2] The carry (borrow) flag is also set if the subtraction of 
                                              two numbers requires a borrow into the most significant 
                                              (leftmost) bits subtracted.
                                    
                                    A[31]   B[31]   Result[31]  MSB Expected
                                         
*/ 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input  logic [31:0] SrcAE,
    input  logic [31:0] SrcBE,
    input  logic [3:0]  ALUControlE,
    
    output logic [31:0] ALUResultE,
    output logic        Z,                     //Zero Flag
    output logic        OV,                    //Overflow Flag 
    output logic        CY,                    //Carry flag 
    output logic        N,                     //Sign/Negative Flag
    output logic        lts,
    output logic        ltu
    );
    
    // One shared adder: A + B, or A + ~B + 1 (carry-in rides in the LSB)
    logic        sub;
    logic [31:0] bx;
    logic [33:0] t;
    logic [31:0] sum;
    
    assign sub = (ALUControlE == 4'b0001);
    assign bx  = SrcBE ^ {32{sub}};
    // 33-bit addition to preserve carry-out
    assign t   = {1'b0, SrcAE, 1'b1} + {1'b0, bx, sub};

    assign sum = t[32:1];

  // Comparisons straight from the operands, not from the subtract result
  assign Z  = (SrcAE == SrcBE) ? 1:0;
  assign lts = ($signed(SrcAE) < $signed(SrcBE)) ? 1:0;
  assign ltu = (SrcAE < SrcBE) ? 1:0;

  always_comb begin
    case (ALUControlE)
      4'b0000: ALUResultE = sum;
      4'b0001: ALUResultE = sum;
      4'b0010: ALUResultE = SrcAE << SrcBE[4:0];
      4'b0011: ALUResultE = {31'b0, lts};
      4'b0100: ALUResultE = {31'b0, ltu};
      4'b0101: ALUResultE = SrcAE ^ SrcBE;
      4'b0110: ALUResultE = SrcAE >> SrcBE[4:0];
      4'b0111: ALUResultE = $signed(SrcAE) >>> SrcBE[4:0];
      4'b1000: ALUResultE = SrcAE | SrcBE;
      4'b1001: ALUResultE = SrcAE & SrcBE;
      default: ALUResultE = 32'b0;
    endcase
  end

  // Old flag names kept so the controller is unchanged
  assign N  = ALUResultE[31];
  
  logic is_add, is_sub;
  assign is_add = (ALUControlE == 4'b0);
  assign is_sub = (ALUControlE == 4'b1);
  assign OV = (is_add && (SrcAE[31] == SrcBE[31]) && (sum[31] != SrcAE[31])) ||
              (is_sub && (SrcAE[31] != SrcBE[31]) && (sum[31] != SrcAE[31]));
  assign CY = (is_add || is_sub) && t[33];   // for SUB: 1 = no borrow
endmodule



