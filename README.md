# 5-Stage-Pipelined-RISC-V-Processor-
Implementing 5-stage pipeline microarchitecture of RV32I ISA on AMD Vivado. I used the textbook "Digital Design and Computer Architecture" Harris, Harris as reference for this project. As of now, i have implemented all instructions.
I have also completed complete RTL to GDII physical design flow using LibreLane & achieved zero violations. 
Performance Metrics: Clock frequency: 40 MHz, Power: 13.6 mW, Area: 235.4k um2    
                     
Note: 
The SystemVerilog Design files are converted into Verilog using sv2v before running LibreLane.
While reproducing the work, replace the InstrMem.sv in design folder with InstrMem.sv in Physical Design folder as the previous file is not synthesizable due to initial keyword.
<img width="1000" height="1015" alt="Top_Module" src="https://github.com/user-attachments/assets/cb7301d5-c3dc-4155-a082-abdf2bc1b628" />

