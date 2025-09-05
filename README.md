⚙️ Features

    Instruction Set: 16 opcodes supporting arithmetic, memory, and control flow           
    operations
    
    RTL Modules:
          ALU
          Control Unit
          Registers
          Memory Interface
          UART Communication
    
    Cycle-Accurate Design: Simulates instruction execution step-by-step
    
    Verification: All modules tested with Verilog testbenches and behavioral              
    validation

🛠️ Technical Details

    Language: Verilog HDL
    
    Design Approach: Prototyped instruction set in Logisim before full Verilog            
    implementation

🚀 Results

    Successfully wrote and executed a fibonacci program in Assembly on the CPU
    
    Verified instruction handling and register transfers
    
    Demonstrated modular design enabling scalability

🕹️ How to Use

    1.) Write Your Program in the program.asm file in Assembly. On running, the 
        .asm file will automatically be assembled into binary and loaded into the moemory.
        
    2.) Edit the tb_cpu.v file so that the terminal outputs the correct values for your desired purpose.

    3.) Run the following command in the terminal to run the CPU:
    
            iverilog -o sim tb_cpu.v cpu.v eight_bit_adder_subtractor.v datapath.v controller_sequencer.v cb_register.v ram.v program_counter.v 

    4.) Enjoy my Project!
