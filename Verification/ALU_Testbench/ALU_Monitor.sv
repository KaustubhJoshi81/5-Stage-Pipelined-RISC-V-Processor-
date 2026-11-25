class ALU_Monitor;
  
  virtual ALU_intf ALU_vif;
  
  mailbox ALU_mon2scb;
  
  function new(virtual ALU_intf ALU_vif, mailbox ALU_mon2scb);
  	//from testbench
    this.ALU_vif = ALU_vif;
    //from environment
    this.ALU_mon2scb = ALU_mon2scb;
  endfunction
  
  task main;
    forever begin
      ALU_Transaction ALU_trans;
      ALU_trans = new();
      @(ALU_vif.monitor_cb);
      if(ALU_vif.monitor_cb.valid) begin
        ALU_trans.SrcAE     	= ALU_vif.monitor_cb.SrcAE;
        ALU_trans.SrcBE     	= ALU_vif.monitor_cb.SrcBE;
        ALU_trans.ALUControlE   = ALU_vif.monitor_cb.ALUControlE;
        ALU_trans.ALUResultE    = ALU_vif.monitor_cb.ALUResultE;
        ALU_trans.Z     		= ALU_vif.monitor_cb.Z;
        ALU_trans.OV     		= ALU_vif.monitor_cb.OV;
        ALU_trans.CY     		= ALU_vif.monitor_cb.CY;
        ALU_trans.N     		= ALU_vif.monitor_cb.N;
        ALU_trans.lts     		= ALU_vif.monitor_cb.lts;
        ALU_trans.ltu     		= ALU_vif.monitor_cb.ltu;
        ALU_mon2scb.put(ALU_trans);
        ALU_trans.display("[ Monitor ]");
      end
    end
  endtask
  
endclass