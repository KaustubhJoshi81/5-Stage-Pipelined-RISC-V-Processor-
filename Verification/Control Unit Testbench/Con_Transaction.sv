class Con_Transaction;
  
  //declaring the transaction items
  rand bit [6:0] OpD;
  rand bit [2:0] funct3D, funct3E;
  rand bit       funct7b5D, JumpE, BranchE, Z, lts, ltu;
  bit       	 RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
  bit [2:0] 	 ResultSrcD, ImmSrcD;
  bit [3:0]      ALUControlD;
  bit [1:0]      PCSrcE;
  static bit verbose = 0;
  
  function void display(string name);
    if(!verbose)
      return;
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    //$display("- a = %0d, b = %0d, s = %0d",SrcAE ,SrcBE, ALUControlE);
    //$display("- y = %0d, Z = %0d, OV = %0d, CY = %0d, N = &0d, lts = %0d, ltu = %0d",
    //         ALUResultE, Z, OV, CY, N, lts, ltu);
    $display("-------------------------");
  endfunction
endclass