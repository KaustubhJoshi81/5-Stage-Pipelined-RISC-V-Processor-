interface Con_intf(input logic clk,reset);
  
  //declaring the signals
  logic [6:0] OpD;
  logic [2:0] funct3D, funct3E;
  logic       funct7b5D, JumpE, BranchE, Z, lts, ltu;
  logic       RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
  logic [2:0] ResultSrcD, ImmSrcD;
  logic [3:0] ALUControlD;
  logic [1:0] PCSrcE;
  logic       valid;
  
  clocking driver_cb@(posedge clk);
    default input #1step output #2ns;
    input RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, ResultSrcD, ImmSrcD, 
    	  ALUControlD, PCSrcE;
    output OpD, funct3D, funct3E, funct7b5D, JumpE, BranchE, Z, lts, ltu,valid;
  endclocking
  
  clocking monitor_cb@(posedge clk);
    input #1step OpD, funct3D, funct3E, funct7b5D, JumpE, BranchE, Z, lts, ltu, RegWriteD, 			     MemWriteD, JumpD, BranchD, ALUSrcD, ResultSrcD, ImmSrcD, ALUControlD, 					  PCSrcE, valid;
  endclocking
  
endinterface