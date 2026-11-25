`include "ALU_Transaction.sv"
`include "ALU_Generator.sv"
`include "ALU_Driver.sv"
`include "ALU_Monitor.sv"
`include "ALU_Coverage.sv"
`include "ALU_Scoreboard.sv"


class ALU_Environment;
  
  //generator, driver, monitor, scoreboard instance
  ALU_Generator  gen;
  ALU_Driver     driv;
  ALU_Monitor 	 mon;
  ALU_Scoreboard scb;
  
  //mailbox handle's
  mailbox ALU_gen2driv;
  mailbox ALU_mon2scb;
  
  //virtual interface
  virtual ALU_intf ALU_vif;
  
  //constructor
  function new(virtual ALU_intf ALU_vif);
    //get the interface from test
    this.ALU_vif = ALU_vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    ALU_gen2driv = new();
    ALU_mon2scb = new();
    //creating generator, driver, monitor, scoreboard
    gen  = new(ALU_gen2driv);
    driv = new(ALU_vif,ALU_gen2driv);
    mon  = new(ALU_vif, ALU_mon2scb);
    scb  = new(ALU_mon2scb);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ALU_ended.triggered);
    wait(gen.ALU_repeat_count == driv.ALU_no_transactions);
    wait(gen.ALU_repeat_count == scb.ALU_no_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    scb.report();
    $finish;
  endtask
  
endclass