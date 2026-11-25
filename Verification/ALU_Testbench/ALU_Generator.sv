class ALU_Generator;
  
  //declaring transaction class 
  rand ALU_Transaction ALU_trans;
  
  //repeat count, to specify number of items to generate
  int  ALU_repeat_count;
  
  //mailbox, to generate and send the packet to driver
  mailbox ALU_gen2driv;
  
  //event, to indicate the end of transaction generation
  event ALU_ended;
  
  //constructor
  function new(mailbox ALU_gen2driv);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.ALU_gen2driv = ALU_gen2driv;
  endfunction
  
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    repeat(ALU_repeat_count) begin
    ALU_trans = new();
      if( !ALU_trans.randomize() ) $fatal("Gen:: transaction randomization failed");
      ALU_trans.display("[ Generator ]");
      ALU_gen2driv.put(ALU_trans);
    end
    -> ALU_ended; //triggering indicatesthe end of generation
  endtask
  
endclass