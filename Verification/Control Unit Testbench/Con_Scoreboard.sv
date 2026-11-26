import "DPI-C" function void Con_refmodel(
  input int unsigned OpD, input int unsigned funct3D, input int unsigned funct7b5D, 
  input int unsigned JumpE, input int unsigned BranchE, input int unsigned funct3E, 
  input int unsigned Z, input int unsigned lts, input int unsigned ltu, 
  output int unsigned RegWriteD, output int unsigned ResultSrcD, 
  output int unsigned MemWriteD, output int unsigned JumpD, 
  output int unsigned BranchD, output int unsigned ALUControlD, 
  output int unsigned ALUSrcD, output int unsigned ImmSrcD, output int unsigned PCSrcE);

class Con_Scoreboard;
  
  mailbox Con_mon2scb;
  Con_Coverage cov;
  
  int Con_no_transactions;
  int Con_pass_count;
  int Con_fail_count;
  
  function new(mailbox Con_mon2scb);
    this.Con_mon2scb = Con_mon2scb;
    cov = new();
  endfunction
  
  task main();
    Con_Transaction Con_trans;
    bit 	  RegWriteD_expected;    
    bit [2:0] ResultSrcD_expected;       
	bit 	  MemWriteD_expected;    
    bit 	  JumpD_expected;	       
    bit 	  BranchD_expected;	     
    bit [3:0] ALUControlD_expected;  
    bit 	  ALUSrcD_expected;	     
    bit [2:0] ImmSrcD_expected;
    bit [1:0] PCSrcE_expected;
    
    forever begin
      Con_mon2scb.get(Con_trans);
      cov.sample(Con_trans);
      
      Con_refmodel(
      Con_trans.OpD, Con_trans.funct3D, Con_trans.funct7b5D, Con_trans.JumpE, 				  Con_trans.BranchE, Con_trans.funct3E, Con_trans.Z, Con_trans.lts, Con_trans.ltu,    
      RegWriteD_expected, ResultSrcD_expected, MemWriteD_expected, JumpD_expected,			  BranchD_expected, ALUControlD_expected, ALUSrcD_expected, ImmSrcD_expected, 
      PCSrcE_expected    
      );
      
      if(
      RegWriteD_expected == Con_trans.RegWriteD && 
      ResultSrcD_expected == Con_trans.ResultSrcD && 
      MemWriteD_expected == Con_trans.MemWriteD && 
      JumpD_expected == Con_trans.JumpD && BranchD_expected == Con_trans.BranchD && 
      ALUControlD_expected == Con_trans.ALUControlD && 
      ALUSrcD_expected == Con_trans.ALUSrcD && ImmSrcD_expected == Con_trans.ImmSrcD &&
      PCSrcE_expected == Con_trans.PCSrcE
      )
        	Con_pass_count++;
      else begin
        $error({
        "[SCB] CONTROLLER MISMATCH #%0d:\n",
        "OpD = %0d |",
        "funct3D = %0d |",
		"funct7b = %0d |",
		"JumpE   = %0d |",
		"BranchE = %0d |",
		"funct3E = %0d |",
		"Z       = %0d |",
		"lts     = %0d |",
		"ltu     = %0d |",
        "RegWriteD_expected   = %0b, got RegWriteD   = %0b | ",
        "ResultSrc_expected   = %0b, got ResultSrc   = %0b | ",
        "MemWriteD_expected   = %0b, got MemWriteD   = %0b | ",
        "JumpD_expected       = %0b, got JumpD       = %0b | ",
        "BranchD_expected     = %0b, got BranchD     = %0b | ",
        "ALUControlD_expected = %0b, got ALUControlD = %0b | ",
        "ALUSrcD_expected     = %0b, got ALUSrcD     = %0b | ",
        "ImmSrcD_expected     = %0b, got ImmSrcD     = %0b | ",
        "PCSrcE_expected      = %0b, got PCSrcE      = %0b"
        },
        Con_no_transactions, Con_trans.OpD, Con_trans.funct3D, 
        Con_trans.funct7b5D, Con_trans.JumpE, Con_trans.BranchE,
        Con_trans.funct3E, Con_trans.Z, 
        Con_trans.lts, Con_trans.ltu,
        RegWriteD_expected,   Con_trans.RegWriteD,
        ResultSrcD_expected,  Con_trans.ResultSrcD,
        MemWriteD_expected,   Con_trans.MemWriteD,
        JumpD_expected,       Con_trans.JumpD,
        BranchD_expected,     Con_trans.BranchD,
        ALUControlD_expected, Con_trans.ALUControlD,
        ALUSrcD_expected,     Con_trans.ALUSrcD,
        ImmSrcD_expected,     Con_trans.ImmSrcD,
        PCSrcE_expected,      Con_trans.PCSrcE
    );
        	Con_fail_count++;
      end
      Con_no_transactions++;
      Con_trans.display("[ Scoreboard ]");
    end
  endtask
  
  function void report();
    real pct;
    pct = (Con_no_transactions == 0) ? 0.0: (100.0 * Con_pass_count)/Con_no_transactions;
 
    $display("==================================================");
    $display(" SCOREBOARD SUMMARY");
    $display("   Total transactions : %0d", Con_no_transactions);
    $display("   Passed             : %0d", Con_pass_count);
    $display("   Failed             : %0d", Con_fail_count);
    $display("   Correct results    : %0.2f %%", pct);
    if (Con_fail_count == 0 && Con_no_transactions > 0)
      $display("   TEST PASSED");
    else
      $display("   TEST FAILED");
    $display("==================================================");
    
    cov.report();
    
  endfunction
  
endclass