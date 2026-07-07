`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 15:19:07
// Design Name: 
// Module Name: HazardUnit
// Project Name: 
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


module HazardUnit(
    input  logic       reset,
    
    input  logic [4:0] Rs1E,                        //Register 1 [Execute Stage] 
    input  logic [4:0] Rs2E,                        //Register 2 [Execute Stage]
    input  logic [4:0] RdM,                         //Destination Register [Memory Stage]
    input  logic [4:0] RdW,                         //Destination Register [Write-Back Stage]
    input  logic       RegWriteM,                   //Registe file Write Enable Signal [Memory Stage]
    input  logic       RegWriteW,                   //Registe file Write Enable Signal [Write-Back Stage]
    output logic [1:0] ForwardAE,                   //Control signal for 3:1 Mux for choosing SrcAE ALU signal
    output logic [1:0] ForwardBE,                   //Control signal for 3:1 Mux for choosing SrcBE ALU signal
    
    input  logic       ResultSrcE0,                 //To detect load (& auipc) instruction for Data Hazards
    input  logic [4:0] Rs1D,                        //Register 1 [Decode Stage]
    input  logic [4:0] Rs2D,                        //Register 2 [Decode Stage}
    input  logic [4:0] RdE,                         //Destination Register [Execution Stage]
    output logic       StallF,                      //Stall Fetch Stage Register
    output logic       StallD,                      //Stall Decode Stage Register
    
    input  logic [1:0] PCSrcE,                      //Detecting J&B-type instr for Control Hazards
    output logic       FlushD,                      //Clear Decode Stage 
    output logic       FlushE                       //Clear Execution Stage [No-operation (NOP)]   
    );

//-----------------------------------------Data Hazards => Forwarding---------------------------------------------//    
    
    always_comb begin
        if (reset) begin
            ForwardAE = 2'b00;
            end
        else if ((Rs1E == RdM) & Rs1E != 0 & RegWriteM)
            ForwardAE = 2'b10;
        else if ((Rs1E == RdW) & Rs1E != 0 & RegWriteW)
            ForwardAE = 2'b01;
        else 
            ForwardAE = 2'b00;
    end     
    
    always_comb begin
        if (reset)
            ForwardBE = 2'b00;
        else if ((Rs2E == RdM) & Rs2E != 0 & RegWriteM)
            ForwardBE = 2'b10;
        else if ((Rs2E == RdW) & Rs2E != 0 & RegWriteW)
            ForwardBE = 2'b01;
        else 
            ForwardBE = 2'b00;
    end
    
//------------------------------------Data Hazards => Stalling the pipeline----------------------------------------//    
   
    logic  lwStall;
    
    assign lwStall = (reset) ? 0: (((ResultSrcE0) & (Rs1D == RdE | Rs2D == RdE)) ? 1:0);
    
//    always_comb begin
//        lwStall = (ResultSrcE0) & (Rs1D == RdE | Rs2D == RdE);
//        if(reset) begin
//            StallD = 1'b0;
//            StallF = 1'b0; 
//            FlushD = 1'b0;
//            FlushE = 1'b0;           
//            end
//        else if (lwStall) begin
//            StallD = 1'b1;
//            StallF = 1'b1;
//            FlushE = 1'b1;
//            end
//        else if (PCSrcE != 2'b00) begin
//            FlushD = 1'b1;
//            FlushE = 1'b1;
//            end 
//        else begin
//            StallD = 1'b0;
//            StallF = 1'b0;
//            FlushD = 1'b0;
//            FlushE = 1'b0;
//        end
//    end
    
    assign StallD  = (reset) ? 0: (lwStall);
    assign StallF  = (reset) ? 0: (lwStall);

//  Execute Stage Register is also flushed when Fetch and Decode Stages are stalled. The complete FlushE assignment 
//  is written below [control hazard]
    
//---------------------------Control Hazard => Flush Decode & Execute Stages---------------------------------------//
    
    assign FlushD = (reset) ? 0: (PCSrcE != 2'b00);                //flush for jal, jalr & B-type instructions
    assign FlushE = (reset) ? 0: ((PCSrcE != 2'b00) | lwStall);    //flush for jal, jalr, B-type and load instructions
              
endmodule
