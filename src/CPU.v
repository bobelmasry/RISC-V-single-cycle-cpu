`timescale 1ns / 1ps


module main(
input clk, rst, SSDClk, input [1:0] LEDSel, input [3:0] SSDSel,     
output reg [15:0] LED, output reg [12:0] SSD
    );
wire [31:0] PC_input_IF_stage;
wire [31:0] PC_IF_stage;
wire [31:0] PC_Add4_IF_stage = PC_IF_stage + 32'd4;
Register #(32) ProgramCounter(.clk(clk), .load(~stall), .rst(rst), .D(PC_input_IF_stage), .Q(PC_IF_stage));


//Instruction Fetching
wire [31:0] IF_data;
InstrMem InstructionMemory(.addr(PC_IF_stage[7:2]),.data_out(IF_data));
wire [6:0] opcode_IF_stage = IF_data[6:0];
wire [2:0] funct3_IF_stage = IF_data[14:12];
wire isHalt;
wire [31:0] nop_IF = 32'b00000000000000000000000000110011;
wire [31:0] outputIF_IF = (BranchConfirm_MEM) ? nop_IF: IF_data; 
assign isHalt = (opcode_IF_stage == 7'b0001111 || opcode_IF_stage == 7'b1110011) ? 1 : 0;
////////////End of IF 
wire [63:0] IF_ID_reg;
//Docs
//[63:32] is the PC
//[31:0] is the IF_data
Register #(64) RG_IF_ID(.clk(clk), .load(~stall), .rst(rst), .D({PC_IF_stage, outputIF_IF}), .Q(IF_ID_reg)); 
////////////Start of ID
wire [31:0] PC_ID_stage = IF_ID_reg[63:32];
wire [31:0] IF_data_ID_stage = IF_ID_reg[31:0];
//Hazard detection unit
wire stall;
hazardDetectionUnit HDU(
    .if_id_RegisterRs1(IF_data_ID_stage[19:15]), .if_id_RegisterRs2(IF_data_ID_stage[24:20]),
    .id_ex_RegisterRd(rd_EX_stage), .id_ex_MemRead(memRead_EX),
    .stall(stall)
);

//Control Signals
wire branchSignal_ID, memoryReadSignal_ID, memoryWriteSignal_ID, memoryToRegisterSignal_ID,
                ALUSourceSignal_ID, registerWriteSignal_ID, jumpSignal_ID;
wire [1:0] ALUOpSignal_ID;
control ControlSignals(.instr(IF_data_ID_stage), .branch(branchSignal_ID), .jump(jumpSignal_ID),
                        .memRead(memoryReadSignal_ID), .MemtoReg(memoryToRegisterSignal_ID), .MemWrite(memoryWriteSignal_ID),
                        .ALUSrc(ALUSourceSignal_ID), .RegWrite(registerWriteSignal_ID), .ALUOp(ALUOpSignal_ID) );

wire [2:0] SpecialInstructionCodes_ID;
SpecialInstructionControlUnit SICU(.opcode(IF_data_ID_stage[6:2]), .sel(SpecialInstructionCodes_ID));

wire [11:0] allControl_ID_stage = {memoryReadSignal_ID, memoryWriteSignal_ID, memoryToRegisterSignal_ID, registerWriteSignal_ID,
ALUSourceSignal_ID, ALUOpSignal_ID, branchSignal_ID, jumpSignal_ID, SpecialInstructionCodes_ID};
wire [11:0] controls_Saved_ID_stage;
nMUX #(12) muxControl_ID(.sel(stall | BranchConfirm_MEM), .a(allControl_ID_stage), .b(12'b000000000000), .c(controls_Saved_ID_stage));
//Instruction Decoding
wire RegWrite_WB_stage;
wire [4:0] rd_WB_stage;
wire [31:0] dataWrite_WB, data_rs1_ID, data_rs2_ID;
RegisterFile RF(.clk(clk), .rst(rst), .regWrite(RegWrite_WB_stage), 
                .rs1(IF_data_ID_stage[19:15]), .rs2(IF_data_ID_stage[24:20]), .rd(rd_WB_stage),
                .writeData(dataWrite_WB), .data1(data_rs1_ID), .data2(data_rs2_ID));
//Immediate generator
wire [31:0] Immediate_ID;
ImmGen ImmediateGenerator(.instr(IF_data_ID_stage), .imm(Immediate_ID));



////////////End of ID stage
// module Register #(parameter n = 8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [163:0] ID_EX_reg;
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
//[153:149] shamt/rs2
//[158:154] opcode
//[163:159] rs1
Register #(164) RG_ID_EX(.clk(clk), .load(1'b1), .rst(rst), 
.D({ IF_data_ID_stage[19:15], IF_data_ID_stage[6:2], IF_data_ID_stage[24:20],
controls_Saved_ID_stage,
PC_ID_stage, data_rs1_ID, data_rs2_ID, Immediate_ID, IF_data_ID_stage[30], IF_data_ID_stage[14:12], IF_data_ID_stage[11:7]
}), 
.Q(ID_EX_reg)); 
////////////Start of EX stage
wire [4:0] rd_EX_stage;
assign rd_EX_stage = ID_EX_reg[4:0];
wire [3:0] funct3to7_EX_stage = ID_EX_reg[8:5];
wire [31:0] Immediate_EX_stage = ID_EX_reg[40:9];
wire [31:0] data_rs2_EX_stage = ID_EX_reg[72:41];
wire [31:0] data_rs1_EX_stage = ID_EX_reg[104:73];
wire [31:0] PC_EX_stage = ID_EX_reg[136:105];
wire [1:0] special2BitCode_EX_stage = ID_EX_reg[148:137];
wire special1BitCode_Ex_stage = ID_EX_reg[139];
wire jumpSignal_EX = ID_EX_reg[140];
wire branchSignal_EX = ID_EX_reg[141];
wire [1:0] ALU_Op_EX_stage = ID_EX_reg[143:142];
wire ALU_src_EX_stage = ID_EX_reg[144];
wire regWrite_EX = ID_EX_reg[145];
wire memToReg_EX = ID_EX_reg[146];
wire memWrite_EX = ID_EX_reg[147];
wire memRead_EX;
assign memRead_EX = ID_EX_reg[148];
wire [4:0] shamt_EX_stage = ID_EX_reg[153:149];
wire [4:0] rs2_EX_stage = ID_EX_reg[153:149];
wire [4:0] opcode_EX = ID_EX_reg[158:154];
wire [4:0] rs1_EX_stage = ID_EX_reg[163:159];
//ALU Control
wire [3:0] ALUSelector_EX;
ALU_control ALUC(.ALUop(ALU_Op_EX_stage), .funct3to7(funct3to7_EX_stage), .ALUsel(ALUSelector_EX));

//Forwarding Unit
wire [1:0] forwardA;
wire [1:0] forwardB;
forwardingUnit FU(.ex_mem_RegWrite(regWrite_MEM), .ex_mem_RegisterRd(rd_MEM_stage),
    .id_ex_RegisterRs1(rs1_EX_stage), .id_ex_RegisterRs2(rs2_EX_stage),
    .mem_wb_RegWrite(RegWrite_WB_stage), .mem_wb_RegisterRd(rd_WB_stage),
    .forwardA(forwardA), .forwardB(forwardB)
);
wire [31:0] inputA_EX_stage;
FourXoneMux InputA(.op0(data_rs1_EX_stage), 
                    .op1(dataWrite_WB), 
                    .op2(ALUorSpecialResult_MEM_stage), 
                    .op3(32'b0), .sel(forwardA), .out(inputA_EX_stage));
wire [31:0] inputB_EX_stage;
FourXoneMux InputB(.op0(data_rs2_EX_stage), 
                    .op1(dataWrite_WB), 
                    .op2(ALUorSpecialResult_MEM_stage), 
                    .op3(32'b0), .sel(forwardB), .out(inputB_EX_stage));
//ALU
wire [31:0] secondValue_EX;
wire zeroSignal_EX, carrySignal_EX, overflowSignal_EX, signSignal_EX;
wire [31:0] ALUResult_EX;
nMUX #(32) mux(.sel(ALU_src_EX_stage), .a(inputB_EX_stage), .b(Immediate_EX_stage), .c(secondValue_EX));
//Final Shamt used
wire [4:0] finalShamt_EX = (opcode_EX[3]) ? data_rs2_EX_stage[4:0] : shamt_EX_stage;
prv32_ALU alu (
    .a(inputA_EX_stage),
    .b(secondValue_EX),
    .shamt(finalShamt_EX),
    .alufn(ALUSelector_EX),       // ALUOp
    .r(ALUResult_EX),
    .cf(carrySignal_EX),
    .zf(zeroSignal_EX),
    .vf(overflowSignal_EX),
    .sf(signSignal_EX)
);

//Special instructions - AUIPC, LUI, JAL, JALR
wire [31:0] ShiftedImmediate_EX;
shifter SpecialShifter(
    .a(Immediate_EX_stage), .shamt(5'b01100),
    .type(2'b00),
    .r(ShiftedImmediate_EX)
);
wire [31:0] PC_Add4_EX_stage = PC_EX_stage+32'd4;
wire [31:0] specialInstructionResult_EX;
SpecialInstructionAdder SIA(.Immediate(ShiftedImmediate_EX), 
.PC(PC_EX_stage), .PC_Add4(PC_Add4_EX_stage), .sel(special2BitCode_EX_stage), .result(specialInstructionResult_EX));

//Choose between special instruction or ALU result to be written
wire [31:0] ALUorSpecialResult_EX_stage;
nMUX #(32) muxALUorSpecialData(.sel(special1BitCode_Ex_stage), .a(ALUResult_EX), .b(specialInstructionResult_EX), .c(ALUorSpecialResult_EX_stage));

wire [31:0] PC_Imm_EX_stage = PC_EX_stage + Immediate_EX_stage;
wire [31:0] PC_RS1_Imm_EX_stage = data_rs1_EX_stage + Immediate_EX_stage;
wire [31:0] PC_Branch_EX_stage = (opcode_EX == 5'b11001) ? PC_RS1_Imm_EX_stage : PC_Imm_EX_stage;

// Control checking for flushing
wire [9:0] allControl_EX = {memRead_EX, memWrite_EX, memToReg_EX, regWrite_EX, branchSignal_EX, jumpSignal_EX,
 zeroSignal_EX, carrySignal_EX, overflowSignal_EX, signSignal_EX};
wire [9:0] controls_Saved_EX_stage;
nMUX #(12) muxControl_EX(.sel(BranchConfirm_MEM), .a(allControl_EX), .b(12'b000000000000), .c(controls_Saved_EX_stage));

//End of execution stage
// module Register #(parameter n = 8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [113:0] EX_MEM_reg;
//Docs
//[4:0] rd rd_EX_stage
//[36:5] rs2 data_rs2_EX_stage
//[68:37] ALUorSpecialResult ALUorSpecialResult_EX_stage
//[72:69] ALUBranchSignals {zero, sign, carry, overflow}
//[104:73] PC_Branch PC_Branch_EX_stage
//[110:105] Controls SourceSignals_EX_stage
//[113:111] funct3 funct3to7_EX_stage[2:0]
Register #(114) RG_EX_MEM(.clk(clk), .load(1'b1), .rst(rst), 
.D({
funct3to7_EX_stage[2:0], controls_Saved_EX_stage[9:4],
PC_Branch_EX_stage, controls_Saved_EX_stage[3:0],
ALUorSpecialResult_EX_stage, inputB_EX_stage, rd_EX_stage
}), 
.Q(EX_MEM_reg)); 
//start of memory stage
wire [4:0] rd_MEM_stage;
assign rd_MEM_stage = EX_MEM_reg[4:0];
wire [31:0] rs2_MEM_stage = EX_MEM_reg[36:5];
wire [31:0] ALUorSpecialResult_MEM_stage;
assign ALUorSpecialResult_MEM_stage  = EX_MEM_reg[68:37];
wire signSignal_MEM = EX_MEM_reg[69];
wire overflowSignal_MEM = EX_MEM_reg[70];
wire carrySignal_MEM = EX_MEM_reg[71];
wire zeroSignal_MEM = EX_MEM_reg[72];
wire [31:0] PC_branch_address_MEM_stage = EX_MEM_reg[104:73];
wire memRead_MEM = EX_MEM_reg[110];
wire memWrite_MEM = EX_MEM_reg[109];
wire memToReg_MEM = EX_MEM_reg[108];
wire regWrite_MEM;
assign regWrite_MEM = EX_MEM_reg[107];
wire branchSignal_MEM = EX_MEM_reg[106];
wire jumpSignal_MEM = EX_MEM_reg[105];
wire [2:0] funct3_MEM_stage = EX_MEM_reg[113:111];
// branch controls
//Branch address logic for Exexution stage
wire BranchConfirm_MEM;
BranchControlUnit BCU(.funct3(funct3_MEM_stage), .zeroSignal(zeroSignal_MEM), .carrySignal(carrySignal_MEM), 
                      .overflowSignal(overflowSignal_MEM), .signSignal(signSignal_MEM), .branchSignal(branchSignal_MEM),
                      .BranchConfirm(BranchConfirm_MEM));

//Branch decisions
wire [31:0] PC_Temp_MEM;
// select between branch and PC+4
nMUX #(32) BranchMux(.sel(BranchConfirm_MEM | jumpSignal_MEM), .a(PC_Add4_IF_stage), .b(PC_branch_address_MEM_stage), .c(PC_Temp_MEM));
// Then, if halt, keep PC
nMUX #(32) HaltMux(.sel(isHalt),
    .a(PC_Temp_MEM),       // Normal Branch
    .b(PC_IF_stage),  // Current PC
    .c(PC_input_IF_stage)
);

// Memory
wire [7:0] MemoryAddress_MEM_stage;
wire [31:0] MemoryOutput_MEM_stage;
assign MemoryAddress_MEM_stage = ALUorSpecialResult_MEM_stage[7:0];
DataMem DataMemory(.clk(clk), .MemRead(memRead_MEM), .MemWrite(memWrite_MEM),
                    .addr(MemoryAddress_MEM_stage), .data_in(rs2_MEM_stage), .data_out(MemoryOutput_MEM_stage), .funct3(funct3_MEM_stage));
//End of memory stage
// module Register #(parameter n = 8)(input clk, load, rst, input [n-1:0] D, output [n-1:0] Q);
wire [70:0] MEM_WB_reg;
//Docs
//[31:0] DataMem_WB_stage MemoryOutput_MEM_stage
//[63:32] ALU_SpecialResult_WB_stage ALUorSpecialResult_MEM_stage
//[64] RegWrite_WB_stage control_MEM_stage[2]
//[65] MemToReg_WB_stage control_MEM_stage[3]
//[70:66] rd_WB_stage rd_MEM_stage
Register #(71) RG_MEM_WB(.clk(clk), .load(1'b1), .rst(rst), 
.D({rd_MEM_stage,
memToReg_MEM, regWrite_MEM, ALUorSpecialResult_MEM_stage, MemoryOutput_MEM_stage
}), 
.Q(MEM_WB_reg)); 
wire[31:0] DataMem_WB_stage = MEM_WB_reg[31:0];
wire [31:0] ALU_SpecialResult_WB_stage = MEM_WB_reg[63:32] ; 
assign RegWrite_WB_stage  = MEM_WB_reg[64];
wire MemToReg_WB_stage  = MEM_WB_reg[65];
assign rd_WB_stage = MEM_WB_reg[70:66];
///Start of Write back
//Data Write result

nMUX #(32) mux2(.sel(MemToReg_WB_stage), .a(ALU_SpecialResult_WB_stage), .b(DataMem_WB_stage), .c(dataWrite_WB));



always @(*) begin
    case (LEDSel)
        2'b00: begin
            LED = IF_data[15:0];
        end 
        2'b01: begin
            LED = IF_data[31:16];
        end
        2'b11: begin
        //Empty for now
            LED = 16'b1111111111111111;
        end
    endcase
    case (SSDSel)
        4'b0000: begin
            SSD = PC_IF_stage[12:0];
        end
        4'b0001: begin
            SSD = PC_Add4_IF_stage[12:0];
        end
        4'b0010: begin
            SSD = PC_branch_address_MEM_stage[12:0];
        end
        4'b0011: begin
            SSD = PC_input_IF_stage[12:0];
        end
        4'b0100: begin
            SSD = data_rs1_ID[12:0];
        end
        4'b0101: begin
            SSD = data_rs2_ID[12:0];
        end
        4'b0110: begin
            SSD = dataWrite_WB[12:0];
        end
        4'b0111: begin
            SSD = Immediate_ID[12:0];
        end
        4'b1000: begin
            SSD = Immediate_ID[12:0];
        end
        4'b1001: begin
            SSD = secondValue_EX[12:0];
        end
        4'b1010: begin
            SSD = ALUResult_EX[12:0];
        end
        4'b1011: begin
            SSD = MemoryOutput_MEM_stage[12:0];
        end
        4'b1100: begin
            SSD = {8'b00000000, rd_WB_stage};
        end
    endcase
end
endmodule
