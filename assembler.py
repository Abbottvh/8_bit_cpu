ISA = {
    "LDA": "00000000",
    "STA": "00000001",
    "ADD_B": "00000010",
    "ADD_C": "00000011",
    "SUB_B": "00000100",
    "SUB_C": "00000101",
    "JMP": "00000110",
    "JC": "00000111",
    "JZ": "00001000",
    "OUT": "00001001",
    "HLT": "00001010",
    "MVI_ACCUM": "00001011",
    "MVI_B": "00001100",
    "MVI_C": "00001101",
    "MOV_A_B": "00001110",
    "MOV_A_C": "00001111"
}

# Categorize instructions
three_byte_instrs = {"LDA", "STA", "JMP", "JC", "JZ"}         # need 16-bit address (2 bytes)
two_byte_instrs = {"MVI_ACCUM", "MVI_B", "MVI_C"}             # need 8-bit immediate
one_byte_instrs = {"ADD_B", "ADD_C", "SUB_B", "SUB_C", "MOV_A_B", "MOV_A_C", "OUT", "HLT"}

def assemble(input_lines):
    output = []
    for line in input_lines:
        parts = line.strip().split()
        if not parts or parts[0].startswith(";"):
            continue
        instr = parts[0]
        if instr not in ISA:
            raise Exception(f"Unknown instruction: {instr}")
        
        output.append(ISA[instr])  # Always add opcode
        
        if instr in three_byte_instrs:
            if len(parts) != 2:
                raise Exception(f"{instr} requires one 16-bit address operand.")
            addr = int(parts[1], 16)
            high_byte = (addr >> 8) & 0xFF
            low_byte = addr & 0xFF
            output.append(format(high_byte, "08b"))
            output.append(format(low_byte, "08b"))
        
        elif instr in two_byte_instrs:
            if len(parts) != 2:
                raise Exception(f"{instr} requires one 8-bit immediate operand.")
            imm = int(parts[1], 16)
            if imm < 0 or imm > 0xFF:
                raise Exception(f"Immediate value out of 8-bit range: {imm}")
            output.append(format(imm, "08b"))

        elif instr in one_byte_instrs:
            if len(parts) != 1:
                raise Exception(f"{instr} does not take any operands.")

    return output

# Assemble the program
with open("program.asm") as f:
    lines = f.readlines()

binary_code = assemble(lines)

# Save to memory file
with open("instructions.mem", "w") as f:
    for bin_line in binary_code:
        f.write(f"{int(bin_line, 2):02X}\n")