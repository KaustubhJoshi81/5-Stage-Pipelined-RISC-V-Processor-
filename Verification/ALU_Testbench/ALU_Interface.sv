interface ALU_intf(input logic clk,reset);
  
  //declaring the signals
  logic [31:0] SrcAE,SrcBE;
  logic [3:0]  ALUControlE;
  logic [31:0] ALUResultE;
  logic 	   Z,OV,CY,N,lts,ltu;
  logic 	   valid;
  
  clocking driver_cb@(posedge clk);
    default input #1step output #2ns;
    input ALUResultE, Z, OV, CY, N, lts, ltu;
    output SrcAE,SrcBE,ALUControlE,valid;
  endclocking
  
  clocking monitor_cb@(posedge clk);
    input #1step SrcAE,SrcBE,ALUControlE,ALUResultE,Z,OV,CY,N,lts,ltu,valid;
  endclocking
  
endinterface