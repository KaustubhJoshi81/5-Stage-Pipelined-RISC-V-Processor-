class ALU_Driver;
  
  //used to count the number of transactions
  int ALU_no_transactions;
  
  //creating virtual interface handle
  virtual ALU_intf ALU_vif;
  
  //creating mailbox handle
  mailbox ALU_gen2driv;
  
  //constructor
  function new(virtual ALU_intf ALU_vif,mailbox ALU_gen2driv);
    //getting the interface
    this.ALU_vif = ALU_vif;
    //getting the mailbox handles from  environment 
    this.ALU_gen2driv = ALU_gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;

    $display("[ DRIVER ] ----- Reset Started -----");
    ALU_vif.driver_cb.SrcAE     	  <= 0;
    ALU_vif.driver_cb.SrcBE     	  <= 0;
    ALU_vif.driver_cb.ALUControlE     <= 0;
    ALU_vif.driver_cb.valid 		  <= 0;
    @(ALU_vif.driver_cb)
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
  //drivers the transaction items to interface signals
  task main;
    forever begin
      ALU_Transaction ALU_trans;
      ALU_gen2driv.get(ALU_trans);
      
      @(ALU_vif.driver_cb);
      ALU_vif.driver_cb.SrcAE     		<= ALU_trans.SrcAE;
      ALU_vif.driver_cb.SrcBE     		<= ALU_trans.SrcBE;
      ALU_vif.driver_cb.ALUControlE     <= ALU_trans.ALUControlE;
      ALU_vif.driver_cb.valid		    <= 1;
      
      @(ALU_vif.driver_cb);
      ALU_vif.driver_cb.valid 			<= 0;
      
      ALU_trans.display("[ Driver ]");
      ALU_no_transactions++;
    end
  endtask
  
endclass
