import "DPI-C" function void ALU_refmodel(
    input  int unsigned SrcAE, SrcBE, ALUControlE,
    output int unsigned ALUResultE,
    output bit Z, OV, CY, N, lts, ltu
);

class ALU_Scoreboard;
  
  mailbox ALU_mon2scb;
  ALU_Coverage cov;
  
  int ALU_no_transactions;
  int ALU_pass_count;
  int ALU_fail_count;
  
  function new(mailbox ALU_mon2scb);
    this.ALU_mon2scb = ALU_mon2scb;
    cov = new();
  endfunction
  
  task main();
    ALU_Transaction ALU_trans;
    bit [31:0] ALUResultE_expected;
    bit Z_expected;
    bit OV_expected;
    bit CY_expected;
    bit N_expected;
    bit lts_expected;
    bit ltu_expected;
    
    forever begin
      ALU_mon2scb.get(ALU_trans);
      cov.sample(ALU_trans);
      ALU_refmodel(ALU_trans.SrcAE, ALU_trans.SrcBE, ALU_trans.ALUControlE, 							   				ALUResultE_expected, Z_expected, OV_expected, CY_expected, 						   				   N_expected, lts_expected, ltu_expected);
      
      if(ALUResultE_expected == ALU_trans.ALUResultE && Z_expected == ALU_trans.Z && 
         OV_expected == ALU_trans.OV && CY_expected == ALU_trans.CY && 
         N_expected == ALU_trans.N && lts_expected == ALU_trans.lts && 
         ltu_expected == ALU_trans.ltu)
        	ALU_pass_count++;
      else begin
        ALU_fail_count++;
        $error("[SCB] MISMATCH #%0d: SrcAE=%0d SrcBE=%0d ALUControlE=%0d | expected_ALUResultE =%0d, got ALUResultE =%0d, Z_expected = %0d, got Z = %0d, OV_expected = %0d, got OV = %0d, CY_expected = %0d, got CY = %0d, N_expected = %0d, got N = %0d, lts_expected = %0d, got lts = %0d, ltu_expected = %0d, got ltu = %0d,",
                ALU_no_transactions,
                ALU_trans.SrcAE, ALU_trans.SrcBE, ALU_trans.ALUControlE, 
                ALUResultE_expected, ALU_trans.ALUResultE,
                Z_expected, ALU_trans.Z,
                OV_expected, ALU_trans.OV,
                CY_expected, ALU_trans.CY,
                N_expected, ALU_trans.N,
                lts_expected, ALU_trans.lts,
                ltu_expected, ALU_trans.ltu
              );
      end
      ALU_no_transactions++;
      ALU_trans.display("[ Scoreboard ]");
    end
  endtask
  
  function void report();
    real pct;
    pct = (ALU_no_transactions == 0) ? 0.0 : (100.0 * ALU_pass_count) / ALU_no_transactions;
 
    $display("==================================================");
    $display(" SCOREBOARD SUMMARY");
    $display("   Total transactions : %0d", ALU_no_transactions);
    $display("   Passed             : %0d", ALU_pass_count);
    $display("   Failed             : %0d", ALU_fail_count);
    $display("   Correct results    : %0.2f %%", pct);
    if (ALU_fail_count == 0 && ALU_no_transactions > 0)
      $display("   TEST PASSED");
    else
      $display("   TEST FAILED");
    $display("==================================================");
    
    cov.report();
    
  endfunction
  
endclass