class Con_Driver;
  
  //used to count the number of transactions
  int Con_no_transactions;
  
  //creating virtual interface handle
  virtual Con_intf Con_vif;
  
  //creating mailbox handle
  mailbox Con_gen2driv;
  
  //constructor
  function new(virtual Con_intf Con_vif,mailbox Con_gen2driv);
    //getting the interface
    this.Con_vif = Con_vif;
    //getting the mailbox handles from  environment 
    this.Con_gen2driv = Con_gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;

    $display("[ DRIVER ] ----- Reset Started -----");
    Con_vif.driver_cb.OpD     	  <= 0;
    Con_vif.driver_cb.funct3D     <= 0;
    Con_vif.driver_cb.funct7b5D   <= 0;
    Con_vif.driver_cb.JumpE       <= 0;
    Con_vif.driver_cb.BranchE     <= 0;
    Con_vif.driver_cb.funct3E     <= 0;
    Con_vif.driver_cb.Z           <= 0;
    Con_vif.driver_cb.lts         <= 0;
    Con_vif.driver_cb.ltu         <= 0;
    Con_vif.driver_cb.valid 	  <= 0;
    @(Con_vif.driver_cb)
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
  //drivers the transaction items to interface signals
  task main;
    forever begin
      Con_Transaction Con_trans;
      Con_gen2driv.get(Con_trans);
      @(Con_vif.driver_cb);
      Con_vif.driver_cb.OpD  	   <= Con_trans.OpD;
      Con_vif.driver_cb.funct3D	   <= Con_trans.funct3D;
      Con_vif.driver_cb.funct7b5D  <= Con_trans.funct7b5D;
      Con_vif.driver_cb.JumpE      <= Con_trans.JumpE;  
      Con_vif.driver_cb.BranchE    <= Con_trans.BranchE;
      Con_vif.driver_cb.funct3E    <= Con_trans.funct3E;
      Con_vif.driver_cb.Z          <= Con_trans.Z;      
      Con_vif.driver_cb.lts        <= Con_trans.lts;    
      Con_vif.driver_cb.ltu        <= Con_trans.ltu;    
      Con_vif.driver_cb.valid 	   <= 1;
      
      @(Con_vif.driver_cb);
      Con_trans.RegWriteD   		<= Con_vif.driver_cb.RegWriteD;
      Con_trans.ResultSrcD			<= Con_vif.driver_cb.ResultSrcD;
      Con_trans.MemWriteD			<= Con_vif.driver_cb.MemWriteD;
      Con_trans.JumpD	    		<= Con_vif.driver_cb.JumpD;	   
      Con_trans.BranchD				<= Con_vif.driver_cb.BranchD;		
      Con_trans.ALUControlD			<= Con_vif.driver_cb.ALUControlD;
      Con_trans.ALUSrcD				<= Con_vif.driver_cb.ALUSrcD;		
      Con_trans.ImmSrcD				<= Con_vif.driver_cb.ImmSrcD;
      Con_trans.PCSrcE				<= Con_vif.driver_cb.PCSrcE;
      Con_vif.driver_cb.valid 		<= 0;
      
      Con_trans.display("[ Driver ]");
      Con_no_transactions++;
    end
  endtask
  
endclass