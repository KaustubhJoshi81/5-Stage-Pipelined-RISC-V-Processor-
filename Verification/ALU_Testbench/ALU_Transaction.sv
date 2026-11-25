class ALU_Transaction;
  
  //declaring the transaction items
  rand bit [31:0] SrcAE;
  rand bit [31:0] SrcBE;
  rand bit [3:0]  ALUControlE;
  bit 	   [31:0] ALUResultE;
  bit 			  Z,OV,CY,N,lts,ltu;
  static bit verbose = 0;
  
  function void display(string name);
    if(!verbose)
      return;
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- a = %0d, b = %0d, s = %0d",SrcAE ,SrcBE, ALUControlE);
    $display("- y = %0d, Z = %0d, OV = %0d, CY = %0d, N = &0d, lts = %0d, ltu = %0d",
             ALUResultE, Z, OV, CY, N, lts, ltu);
    $display("-------------------------");
  endfunction
endclass