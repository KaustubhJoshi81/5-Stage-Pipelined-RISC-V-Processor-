`include "Con_Environment.sv"
program test(Con_intf i_intf);
  
  //declaring environment instance
  Con_Environment env;
  
  initial begin
    //creating environment
    env = new(i_intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.Con_repeat_count = 5000;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram