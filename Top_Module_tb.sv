`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2026 11:56:02
// Design Name: 
// Module Name: Top_Module_tb
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


module Top_Module_tb();

logic        clk;       
logic        reset;     
                        
logic        Z,OV,CY,N; 
logic [31:0] ALUResultW;
logic [31:0] ResultW;   
logic [31:0] WriteDataW;
logic [31:0] ALUResultE;

Top_Module DUT(clk, reset, 
               Z,OV,CY,N, ALUResultW, ResultW, WriteDataW, ALUResultE);

always begin
clk = 0; #10;
clk = 1; #10;
end

// initialize test 
initial begin
reset = 1'b1; # 22; reset = 1'b0;
end

//always @(negedge clk)
//begin
//    if(MemWriteM) begin
//        if(ALUResultW === 100 & WriteDataW === 25) 
//        begin
//        $display("Simulation succeeded");
//        $stop; 
//        end 
////        else if (DataAddress !== 96) begin
////        $display("Simulation failed"); $stop;
////        end 
//    end
//end 

endmodule
