`include "ALU_Environment.sv"
program test(ALU_intf i_intf);
  
  //declaring environment instance
  ALU_Environment env;
  
  initial begin
    //creating environment
    env = new(i_intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.ALU_repeat_count = 10000;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram