`include "Con_Interface.sv"
`include "Con_Test.sv"

module tbench_top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #10 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #2 reset =0;
  end
  
  
  //creatinng instance of interface, in  order to connect DUT and testcase
  Con_intf i_intf(clk,reset);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  Controller DUT (
    .OpD(i_intf.OpD),
    .funct3D(i_intf.funct3D),
    .funct7b5D(i_intf.funct7b5D),
    .JumpE(i_intf.JumpE),
    .BranchE(i_intf.BranchE),
    .funct3E(i_intf.funct3E),
    .Z(i_intf.Z),
    .lts(i_intf.lts),
    .ltu(i_intf.ltu),
    .RegWriteD(i_intf.RegWriteD),
    .ResultSrcD(i_intf.ResultSrcD),
    .MemWriteD(i_intf.MemWriteD),
    .JumpD(i_intf.JumpD),
    .BranchD(i_intf.BranchD),
    .ALUControlD(i_intf.ALUControlD),
    .ALUSrcD(i_intf.ALUSrcD),
    .ImmSrcD(i_intf.ImmSrcD),
    .PCSrcE(i_intf.PCSrcE)
   );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
