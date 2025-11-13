`timescale 1ns / 1ps


module main(
input clk, rst, SSDClk, input [1:0] LEDSel, input [3:0] SSDSel,     
output reg [15:0] LED, output reg [12:0] SSD
    );
wire [31:0] PC_input;
wire [31:0] PC;
wire [31:0] PC_Add4;
wire [31:0] PC_Next;
wire [31:0] PC_Imm;
wire [31:0] PC_RS1_Imm;
wire [31:0] PC_Branch;
Register #(32) ProgramCounter(.clk(clk), .load(1'b1), .rst(rst), .D(PC_input), .Q(PC));


//Instruction Fetching
wire [31:0] IF_data;
InstrMem InstructionMemory(.addr(PC[7:2]),.data_out(IF_data));
wire [6:0] opcode = IF_data[6:0];
wire [2:0] funct3 = IF_data[14:12];
wire isHalt;
//TODO: Will add mechanism to handle halting in the IF stage. Will not add isHalt to any of the registers

assign isHalt = (opcode == 7'b0001111 || opcode == 7'b1110011);
////////////End of IF 
wire [63:0] IF_ID_reg;
//Docs
//[63:32] is the PC
//[31:0] is the IF_data
Register #(64) RG_IF_ID(.clk(clk), .load(1'b1), .rst(rst), .D({PC, IF_data}), .Q(IF_ID_reg)); 
////////////Start of ID
wire [31:0] PC_ID_stage = IF_ID_reg[63:32];
wire [31:0] IF_data_stage = IF_ID_reg[31:0];
//Control Signals
wire branchSignal, memoryReadSignal, memoryWriteSignal, memoryToRegisterSignal,
                ALUSourceSignal, registerWriteSignal, jumpSignal;
wire [1:0] ALUOpSignal;
control ControlSignals(.instr(IF_data_stage), .branch(branchSignal), .jump(jumpSignal),
                        .memRead(memoryReadSignal), .MemtoReg(memoryToRegisterSignal), .MemWrite(memoryWriteSignal),
                        .ALUSrc(ALUSourceSignal), .RegWrite(registerWriteSignal), .ALUOp(ALUOpSignal) );

wire [2:0] SpecialInstructionCodes;
SpecialInstructionControlUnit SICU(.opcode(IF_data_stage[6:2]), .sel(SpecialInstructionCodes));

//Instruction Decoding
wire [31:0] dataWrite, data_rs1, data_rs2;
RegisterFile RF(.clk(clk), .rst(rst), .regWrite(RegWrite_WB_stage), 
                .rs1(IF_data_stage[19:15]), .rs2(IF_data_stage[24:20]), .rd(rd_WB_stage),
                .writeData(dataWrite), .data1(data_rs1), .data2(data_rs2));
//Immediate generator
wire [31:0] Immediate;
ImmGen ImmediateGenerator(.instr(IF_data_stage), .imm(Immediate));

////////////End of ID stage
// module Register #(parameter n = 8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [153:0] ID_EX_reg;
//Docs
//[4:0] rd (IF_data[11:7])
//[8:5] funct3+7 (IF_data[30,14:12]
//[40:9] Immediate
//[72:41] data_rs2
//[104:73] data_rs1
//[136:105] PC
//[148:137] Control signals 
// [148:146] memory:read,write,toReg, [145] regWrite, 
// [144:142] ALU:src,op, [141:140] PC:branch,jump, [139:137] specialInstructions 
//[153:149] shamt
Register #(154) RG_ID_EX(.clk(clk), .load(1'b1), .rst(rst), 
.D({ IF_data_stage[24:20],
memoryReadSignal, memoryWriteSignal, memoryToRegisterSignal, registerWriteSignal,
ALUSourceSignal, ALUOpSignal, branchSignal, jumpSignal, SpecialInstructionCodes,
PC_ID_stage, data_rs1, data_rs2, Immediate, IF_data_stage[30], IF_data_stage[14:12], IF_data_stage[11:7]
}), 
.Q(ID_EX_reg)); 
////////////Start of EX stage
wire [4:0] rd_EX_stage = ID_EX_reg[4:0];
wire [3:0] funct3to7_EX_stage = ID_EX_reg[8:5];
wire [31:0] Immediate_EX_stage = ID_EX_reg[40:9];
wire [31:0] data_rs2_EX_stage = ID_EX_reg[72:41];
wire [31:0] data_rs1_EX_stage = ID_EX_reg[104:73];
wire [31:0] PC_EX_stage = ID_EX_reg[136:105];
wire ALU_src_EX_stage = ID_EX_reg[144];
wire [1:0] ALU_Op_EX_stage = ID_EX_reg[143:142];
wire [5:0] SourceSignals_EX_stage = {ID_EX_reg[148:145], ID_EX_reg[141:140]};
wire [1:0] special2BitCode_EX_stage = ID_EX_reg[148:137];
wire special1BitCode_Ex_stage = ID_EX_reg[139];
wire [4:0] shamt_EX_stage = ID_EX_reg[153:149];
//ALU Control
wire [3:0] ALUSelector;
ALU_control ALUC(.ALUop(ALU_Op_EX_stage), .funct3to7(funct3to7_EX_stage), .ALUsel(ALUSelector));

//ALU
wire [31:0] secondValue;
wire zeroSignal, carrySignal, overflowSignal, signSignal;
wire [31:0] ALUResult;
nMUX #(32) mux(.sel(ALU_src_EX_stage), .a(data_rs2_EX_stage), .b(Immediate_EX_stage), .c(secondValue));
prv32_ALU alu (
    .a(data_rs1_EX_stage),
    .b(secondValue),
    .shamt(shamt_EX_stage),
    .alufn(ALUSelector),       // ALUOp
    .r(ALUResult),
    .cf(carrySignal),
    .zf(zeroSignal),
    .vf(overflowSignal),
    .sf(signSignal)
);

//Special instructions - AUIPC, LUI, JAL, JALR
wire [31:0] ShiftedImmedaite;
shifter SpecialShifter(
    .a(Immediate_EX_stage), .shamt(5'b01100),
    .type(2'b00),
    .r(ShiftedImmediate)
);
assign PC_Add4_EX_stage = PC_EX_stage+32'd4;
wire [31:0] specialInstructionResult;
SpecialInstructionAdder SIA(.Immediate(ShiftedImmediate), 
.PC(PC_EX_stage), .PC_Add4(PC_Add4_EX_stage), .sel(special2BitCode_EX_stage), .result(specialInstructionResult));

//Choose between special instruction or ALU result to be written
wire [31:0] ALUorSpecialResult_EX_stage;
nMUX #(32) muxALUorSpecialData(.sel(special1BitCode_Ex_stage), .a(ALUResult), .b(specialInstructionResult), .c(ALUorSpecialResult_EX_stage));

assign PC_Imm_EX_stage = PC_EX_stage + Immediate_EX_stage;
assign PC_RS1_Imm_EX_stage = data_rs1_EX_stage + Immediate_EX_stage;
assign PC_Branch_EX_stage = (opcode == 7'b1101111 || opcode == 7'b1100111) ? PC_RS1_Imm_EX_stage : PC_Imm_EX_stage;

//End of execution stage
// module Register #(parameter n = 8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [114:0] EX_MEM_reg;
//Docs
//[4:0] rd rd_EX_stage
//[36:5] rs2 data_rs2_EX_stage
//[68:37] ALUorSpecialResult ALUorSpecialResult_EX_stage
//[72:69] ALUBranchSignals {zero, sign, carry, overflow}
//[104:73] PC_Branch PC_Branch_EX_stage
//[110:105] Controls SourceSignals_EX_stage
//[113:111] funct3 funct3to7_EX_stage[2:0]
Register #(115) RG_EX_MEM(.clk(clk), .load(1'b1), .rst(rst), 
.D({
funct3to7_EX_stage[2:0], SourceSignals_EX_stage, PC_Branch_EX_stage, zeroSignal, carrySignal, overflowSignal, signSignal,
ALUorSpecialResult_EX_stage, data_rs2_EX_stage, rd_EX_stage
}), 
.Q(EX_MEM_reg)); 
//start of memroy stage
wire [4:0] rd_MEM_stage = EX_MEM_reg[4:0];
wire [31:0] rs2_MEM_stage = EX_MEM_reg[36:5];
wire [31:0] ALUorSpecialResult_MEM_stage = EX_MEM_reg[68:37];
wire [3:0] ALU_branch_MEM_stage = EX_MEM_reg[72:69];
wire [31:0] PC_branch_address_MEM_stage = EX_MEM_reg[104:73];
wire [6:0] control_MEM_stage = EX_MEM_reg[110:105];
wire [2:0] funct3_MEM_stage = EX_MEM_reg[113:111];
// branch controls
//Branch address logic for Exexution stage
wire BranchConfirm;
BranchControlUnit BCU(.funct3(funct3_MEM_stage), .zeroSignal(ALU_branch_MEM_stage[3]), .carrySignal(ALU_branch_MEM_stage[2]), 
                      .overflowSignal(ALU_branch_MEM_stage[1]), .signSignal(ALU_branch_MEM_stage[0]), .branchSignal(control_MEM_stage[1]),
                      .BranchConfirm(BranchConfirm));

//Branch decisions
wire [31:0] PC_Temp;
// select between branch and PC+4
nMUX #(32) BranchMux(.sel(BranchConfirm), .a(PC+32'd4), .b(PC_branch_address_MEM_stage), .c(PC_Temp));
// Then, if halt, keep PC
nMUX #(32) HaltMux(.sel(isHalt),
    .a(PC_Temp),       // Normal Branch
    .b(PC),  // Current PC
    .c(PC_input)
);

// Memory
wire [7:0] MemoryAddress_MEM_stage;
wire [31:0] MemoryOutput_MEM_stage;
assign MemoryAddress_MEM_stage = ALUorSpecialResult_MEM_stage[7:0];
DataMem DataMemory(.clk(clk), .MemRead(control_MEM_stage[5]), .MemWrite(control_MEM_stage[4]),
                    .addr(MemoryAddress_MEM_stage), .data_in(rs2_MEM_stage), .data_out(MemoryOutput_MEM_stage), .funct3(funct3_MEM_stage));
//End of memory stage
// module Register #(parameter n = 8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [65:0] MEM_WB_stage;
//Docs
//[31:0] DataMem_WB_stage MemoryOutput_MEM_stage
//[63:32] ALU_SpecialResult_WB_stage ALUorSpecialResult_EX_stage
//[64] RegWrite_WB_stage control_MEM_stage[2]
//[65] MemToReg_WB_stage control_MEM_stage[3]
//[70:66] rd_WB_stage rd_MEM_stage
Register #(71) RG_MEM_WB(.clk(clk), .load(1'b1), .rst(rst), 
.D({rd_MEM_stage,
control_MEM_stage[3:2], ALUorSpecialResult_EX_stage, MemoryOutput_MEM_stage
}), 
.Q(MEM_WB_stage)); 
wire[31:0] DataMem_WB_stage = MEM_WB_stage[31:0];
wire [31:0] ALU_SpecialResult_WB_stage = MEM_WB_stage[63:32] ; 
wire RegWrite_WB_stage  = MEM_WB_stage[64];
wire MemToReg_WB_stage  = MEM_WB_stage[65];
wire rd_WB_stage = MEM_WB_stage[70:66];
///Start of Write back
//Data Write result

nMUX #(32) mux2(.sel(MemToReg_WB_stage), .a(ALU_SpecialResult_WB_stage), .b(DataMem_WB_stage), .c(dataWrite));


//Concatenation of control signals
wire [15:0] controlSignalsCombined;
assign controlSignalsCombined = isHalt ? 16'bz : { 2'b00, branchSignal, memoryReadSignal, memoryToRegisterSignal, memoryWriteSignal, 
                ALUSourceSignal, registerWriteSignal, ALUOpSignal, ALUSelector, zeroSignal, BranchConfirm };


always @(*) begin
    case (LEDSel)
        2'b00: begin
            LED = IF_data[15:0];
        end
        2'b01: begin
            LED = IF_data[31:16];
        end
        2'b10: begin
            LED = controlSignalsCombined;
        end
        2'b11: begin
        //Empty for now
            LED = 16'b1111111111111111;
        end
    endcase
    case (SSDSel)
        4'b0000: begin
            SSD = PC[12:0];
        end
        4'b0001: begin
            SSD = PC_Add4[12:0];
        end
        4'b0010: begin
            SSD = PC_Branch[12:0];
        end
        4'b0011: begin
            SSD = PC_input[12:0];
        end
        4'b0100: begin
            SSD = data_rs1[12:0];
        end
        4'b0101: begin
            SSD = data_rs2[12:0];
        end
        4'b0110: begin
            SSD = dataWrite[12:0];
        end
        4'b0111: begin
            SSD = Immediate[12:0];
        end
        4'b1000: begin
            SSD = Immediate[12:0];
        end
        4'b1001: begin
            SSD = secondValue[12:0];
        end
        4'b1010: begin
            SSD = ALUResult[12:0];
        end
        4'b1011: begin
            SSD = MemoryOutput_MEM_stage[12:0];
        end
        
    endcase
end
endmodule
