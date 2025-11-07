import random
import sys

#
# This file needs to be double checked for correctness
#

OPCODES = {
    'LUI': 0b0110111,
    'AUIPC': 0b0010111,
    'JAL': 0b1101111,
    'JALR': 0b1100111,
    'BRANCH': 0b1100011,
    'LOAD': 0b0000011,
    'STORE': 0b0100011,
    'IMM': 0b0010011,
    'REG': 0b0110011,
    'MISC-MEM': 0b0001111,
    'SYSTEM': 0b1110011,
}

INSTRUCTIONS = [
    # R-type: (mnemonic, 'R', funct3, funct7, opcode)
    ('add','R',0b000,0b0000000,OPCODES['REG']),
    ('sub','R',0b000,0b0100000,OPCODES['REG']),
    ('sll','R',0b001,0b0000000,OPCODES['REG']),
    ('slt','R',0b010,0b0000000,OPCODES['REG']),
    ('sltu','R',0b011,0b0000000,OPCODES['REG']),
    ('xor','R',0b100,0b0000000,OPCODES['REG']),
    ('srl','R',0b101,0b0000000,OPCODES['REG']),
    ('sra','R',0b101,0b0100000,OPCODES['REG']),
    ('or','R',0b110,0b0000000,OPCODES['REG']),
    ('and','R',0b111,0b0000000,OPCODES['REG']),
    # I-type (OP-IMM)
    ('addi','I',0b000,None,OPCODES['IMM']),
    ('slli','I-shift',0b001,0b0000000,OPCODES['IMM']),
    ('slti','I',0b010,None,OPCODES['IMM']),
    ('sltiu','I',0b011,None,OPCODES['IMM']),
    ('xori','I',0b100,None,OPCODES['IMM']),
    ('srli','I-shift',0b101,0b0000000,OPCODES['IMM']),
    ('srai','I-shift',0b101,0b0100000,OPCODES['IMM']),
    ('ori','I',0b110,None,OPCODES['IMM']),
    ('andi','I',0b111,None,OPCODES['IMM']),
    # Loads (I-type, LOAD opcode)
    ('lb','I-load',0b000,None,OPCODES['LOAD']),
    ('lh','I-load',0b001,None,OPCODES['LOAD']),
    ('lw','I-load',0b010,None,OPCODES['LOAD']),
    ('lbu','I-load',0b100,None,OPCODES['LOAD']),
    ('lhu','I-load',0b101,None,OPCODES['LOAD']),
    # Stores (S-type)
    ('sb','S',0b000,None,OPCODES['STORE']),
    ('sh','S',0b001,None,OPCODES['STORE']),
    ('sw','S',0b010,None,OPCODES['STORE']),
    # Branches (B-type)
    ('beq','B',0b000,None,OPCODES['BRANCH']),
    ('bne','B',0b001,None,OPCODES['BRANCH']),
    ('blt','B',0b100,None,OPCODES['BRANCH']),
    ('bge','B',0b101,None,OPCODES['BRANCH']),
    ('bltu','B',0b110,None,OPCODES['BRANCH']),
    ('bgeu','B',0b111,None,OPCODES['BRANCH']),
    # U-type
    ('lui','U',None,None,OPCODES['LUI']),
    ('auipc','U',None,None,OPCODES['AUIPC']),
    # J-type and jalr
    ('jal','J',None,None,OPCODES['JAL']),
    ('jalr','I-jalr',0b000,None,OPCODES['JALR']),
]

def gen_random_imm():
    return random.randint(-2048, 2047)

def gen_random_register():
    return random.randint(0, 31)

def generate_random_instruction():
    instr = random.choice(INSTRUCTIONS)
    mnemonic, instr_type, funct3, funct7, opcode = instr
    instruction = {
        'mnemonic': mnemonic,
        'opcode': opcode,
    }
    rd = gen_random_register()
    rs1 = gen_random_register()
    rs2 = gen_random_register()
    imm = gen_random_imm()
    imm = imm & 0xFFF  # Ensure imm is 12 bits and is in 2's complement form

    if instr_type == 'R':
        instruction.update({
            'rd': rd,
            'rs1': rs1,
            'rs2': rs2,
            'funct3': funct3,
            'funct7': funct7,
            'binary' : f"{funct7:07b}{rs2:05b}{rs1:05b}{funct3:03b}{rd:05b}{opcode:07b}"
        })
    elif instr_type in ['I', 'I-shift', 'I-load', 'I-jalr']:
        instruction.update({
            'rd': rd,
            'rs1': rs1,
            'imm': imm,
            'funct3': funct3,
            'binary' : f"{imm:012b}{rs1:05b}{funct3:03b}{rd:05b}{opcode:07b}"
        })
        if instr_type == 'I-shift':
            instruction['shamt'] = random.randint(0, 31)
    elif instr_type == 'S':
        instruction.update({
            'rs1': rs1,
            'rs2': rs2,
            'imm': imm,
            'funct3': funct3,
            'binary' : f"{imm >> 5:07b}{rs2:05b}{rs1:05b}{funct3:03b}{imm & 0x1F:05b}{opcode:07b}"
        })
    elif instr_type == 'B':
        instruction.update({
            'rs1': rs1,
            'rs2': rs2,
            'imm': imm,
            'funct3': funct3,
            'binary' : f"{(imm >> 12) & 0x1b:01b}{(imm >> 5) & 0x3F:06b}{rs2:05b}{rs1:05b}{funct3:03b}{(imm >> 1) & 0xF:04b}{(imm >> 11) & 0x1b:01b}{opcode:07b}"
        })
    elif instr_type == 'U':
        instruction.update({
            'rd': rd,
            'imm': random.randint(0, 0xFFFFF000),
            'binary' : f"{imm >> 12:020b}{rd:05b}{opcode:07b}"
        })
    elif instr_type == 'J':
        instruction.update({
            'rd': rd,
            'imm': imm,
            'binary' : f"{(imm >> 20) & 0x1b:01b}{(imm >> 1) & 0x3FF:010b}{(imm >> 11) & 0x1b:01b}{(imm >> 12) & 0xFF:08b}{rd:05b}{opcode:07b}"
        })

    return instruction

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python randomInstructionGenerator.py <count>")
        sys.exit(1)

    try:
        count = int(sys.argv[1])
        output_instructions = []
        for i in range(count):
            random_instruction = generate_random_instruction()
            output_instructions.append(random_instruction)
            print(random_instruction)

        with open("random_instructions.txt", "w") as f:
            for instr in output_instructions:
                f.write(str(instr['binary']) + "\n")
    except ValueError:
        print("Please provide a valid integer for the number of instructions.")
        sys.exit(1)
