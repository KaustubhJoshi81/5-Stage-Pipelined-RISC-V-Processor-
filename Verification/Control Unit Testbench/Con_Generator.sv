class Con_Generator;
  
  //declaring transaction class 
  rand Con_Transaction Con_trans;
  
  //repeat count, to specify number of items to generate
  int  Con_repeat_count;
  
  //mailbox, to generate and send the packet to driver
  mailbox Con_gen2driv;
  
  //event, to indicate the end of transaction generation
  event Con_ended;
  
  //constructor
  function new(mailbox Con_gen2driv);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.Con_gen2driv = Con_gen2driv;
  endfunction
  
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    repeat(Con_repeat_count) begin
    Con_trans = new();
      if( !Con_trans.randomize() ) $fatal("Gen:: transaction randomization failed");
      Con_trans.display("[ Generator ]");
      Con_gen2driv.put(Con_trans);
    end
    -> Con_ended; //triggering indicatesthe end of generation
  endtask
  
endclass