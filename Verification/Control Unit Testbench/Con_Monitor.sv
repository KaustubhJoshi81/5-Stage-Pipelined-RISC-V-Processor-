class Con_Monitor;
  
  virtual Con_intf Con_vif;
  
  mailbox Con_mon2scb;
  
  function new(virtual Con_intf Con_vif, mailbox Con_mon2scb);
  	//from testbench
    this.Con_vif = Con_vif;
    //from environment
    this.Con_mon2scb = Con_mon2scb;
  endfunction
  
  task main;
    forever begin
      Con_Transaction Con_trans;
      Con_trans = new();
      @(Con_vif.monitor_cb);
      if(Con_vif.monitor_cb.valid) begin
        Con_trans.OpD           = Con_vif.monitor_cb.OpD;
        Con_trans.funct3D       = Con_vif.monitor_cb.funct3D;  
        Con_trans.funct7b5D     = Con_vif.monitor_cb.funct7b5D;  
        Con_trans.JumpE         = Con_vif.monitor_cb.JumpE;
        Con_trans.BranchE       = Con_vif.monitor_cb.BranchE;  
        Con_trans.funct3E       = Con_vif.monitor_cb.funct3E;  
        Con_trans.Z             = Con_vif.monitor_cb.Z;        
        Con_trans.lts           = Con_vif.monitor_cb.lts;      
        Con_trans.ltu           = Con_vif.monitor_cb.ltu;      
        Con_trans.RegWriteD     = Con_vif.monitor_cb.RegWriteD;
        Con_trans.ResultSrcD    = Con_vif.monitor_cb.ResultSrcD;
        Con_trans.MemWriteD     = Con_vif.monitor_cb.MemWriteD;
        Con_trans.JumpD	        = Con_vif.monitor_cb.JumpD;	   
        Con_trans.BranchD	    = Con_vif.monitor_cb.BranchD;	 
        Con_trans.ALUControlD   = Con_vif.monitor_cb.ALUControlD;
        Con_trans.ALUSrcD	    = Con_vif.monitor_cb.ALUSrcD;	 
        Con_trans.ImmSrcD       = Con_vif.monitor_cb.ImmSrcD;
        Con_trans.PCSrcE        = Con_vif.monitor_cb.PCSrcE;
        Con_mon2scb.put(Con_trans);
        Con_trans.display("[ Monitor ]");
      end
    end
  endtask
  
endclass