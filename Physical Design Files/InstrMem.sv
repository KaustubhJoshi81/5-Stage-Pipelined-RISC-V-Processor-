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
    
     reg [31:0] rom_out;
  always @(*) begin
    case (PCF[31:2])
      30'd0: rom_out = 32'h00500113;
      30'd1: rom_out = 32'h00c00193;
      30'd2: rom_out = 32'hff718393;
      30'd3: rom_out = 32'h0023e233;
      30'd4: rom_out = 32'h0041f2b3;
      30'd5: rom_out = 32'h004282b3;
      30'd6: rom_out = 32'h02728863;
      30'd7: rom_out = 32'h0041a233;
      30'd8: rom_out = 32'h00020463;
      30'd9: rom_out = 32'h00000293;
      30'd10: rom_out = 32'h0023a233;
      30'd11: rom_out = 32'h005203b3;
      30'd12: rom_out = 32'h402383b3;
      30'd13: rom_out = 32'h0471aa23;
      30'd14: rom_out = 32'h06002103;
      30'd15: rom_out = 32'h005104b3;
      30'd16: rom_out = 32'h008001ef;
      30'd17: rom_out = 32'h00100113;
      30'd18: rom_out = 32'h00910133;
      30'd19: rom_out = 32'h0221a023;
      30'd20: rom_out = 32'h00210063;
      default: rom_out = 32'h00000013; // nop
    endcase
  end
  assign InstrF = rom_out;
    endmodule
