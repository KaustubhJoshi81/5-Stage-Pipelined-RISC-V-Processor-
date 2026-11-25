`include "ALU_Interface.sv"
`include "ALU_Test.sv"

module tbench_top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #1 reset =0;
  end
  
  
  //creatinng instance of interface, in  order to connect DUT and testcase
  ALU_intf i_intf(clk,reset);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  ALU DUT (
    .SrcAE(i_intf.SrcAE),
    .SrcBE(i_intf.SrcBE),
    .ALUControlE(i_intf.ALUControlE),
    .ALUResultE(i_intf.ALUResultE),
    .Z(i_intf.Z),
    .OV(i_intf.OV),
    .CY(i_intf.CY),
    .N(i_intf.N),
    .lts(i_intf.lts),
    .ltu(i_intf.ltu)
   );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
