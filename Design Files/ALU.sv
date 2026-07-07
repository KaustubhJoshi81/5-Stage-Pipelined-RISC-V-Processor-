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
                                    1       1       0           1           [+ve + (+ve) should result +ve]
                                    0       0       1           0           [-ve + (-ve) should result -ve]
                                    
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
    output logic        N                      //Sign/Negative Flag
    );
    
    logic [31:0] SrcAE_unsign;
    logic [31:0] SrcBE_unsign;
    
    assign SrcAE_unsign = (SrcAE[31]) ? (~SrcAE + 1'b1):SrcAE;
    assign SrcBE_unsign = (SrcBE[31]) ? (~SrcBE + 1'b1):SrcBE;
    
    logic SubFlag;                      //During Subtraction using 2's complement, 
                                        //the final carry out is Subflag.
                                        //Carry flag is complement of the Subflag during sub.
    
    always_comb begin
        
        case (ALUControlE)
            4'b0000: begin
                     {CY, ALUResultE} = SrcAE + SrcBE;                          //add
                     OV = ((SrcAE[31] & SrcBE[31] & ~ALUResultE[31])|(~SrcAE[31] & ~SrcBE[31] & ALUResultE[31]));                                                                                     
                     end
            4'b0001: begin
                     {SubFlag, ALUResultE} = SrcAE + (~SrcBE + 1'b1);           //sub
                     CY = ~SubFlag;                                             
                     OV = ((SrcAE[31] & ~SrcBE[31] & ~ALUResultE[31])|(~SrcAE[31] & SrcBE[31] & ~ALUResultE[31]));
                     end
            4'b0010: ALUResultE = SrcAE << SrcBE[4:0];                          //sll
            4'b0011: ALUResultE = (SrcAE < SrcBE) ? 1:0;                        //slt
            4'b0100: ALUResultE = (SrcAE_unsign < SrcBE_unsign) ? 1:0;          //sltu
            4'b0101: ALUResultE = SrcAE ^ SrcBE;                                //xor
            4'b0110: ALUResultE = SrcAE >> SrcBE[4:0];                          //srl
            4'b0111: ALUResultE = SrcAE >>> SrcBE[4:0];                         //sra
            4'b1000: ALUResultE = SrcAE | SrcBE;                                //or
            4'b1001: ALUResultE = SrcAE & SrcBE;                                //and
        default: begin 
                    ALUResultE = 32'b0;
                    CY         = 1'b0;
                    OV         = 1'b0;
                 end
        endcase
    end
    
    assign Z = (ALUResultE == 32'b0) ? 1:0; 
    assign N  = ALUResultE[31];
    
endmodule
