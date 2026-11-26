`include "Con_Transaction.sv"
`include "Con_Generator.sv"
`include "Con_Driver.sv"
`include "Con_Monitor.sv"
`include "Con_Coverage.sv"
`include "Con_Scoreboard.sv"


class Con_Environment;
  
  //generator, driver, monitor, scoreboard instance
  Con_Generator  gen;
  Con_Driver     driv;
  Con_Monitor 	 mon;
  Con_Scoreboard scb;
  
  //mailbox handle's
  mailbox Con_gen2driv;
  mailbox Con_mon2scb;
  
  //virtual interface
  virtual Con_intf Con_vif;
  
  //constructor
  function new(virtual Con_intf Con_vif);
    //get the interface from test
    this.Con_vif = Con_vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    Con_gen2driv = new();
    Con_mon2scb = new();
    //creating generator, driver, monitor, scoreboard
    gen  = new(Con_gen2driv);
    driv = new(Con_vif,Con_gen2driv);
    mon  = new(Con_vif, Con_mon2scb);
    scb  = new(Con_mon2scb);
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
    wait(gen.Con_ended.triggered);
    wait(gen.Con_repeat_count == driv.Con_no_transactions);
    wait(gen.Con_repeat_count == scb.Con_no_transactions);
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