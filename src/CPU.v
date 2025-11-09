`timescale 1ns / 1ps


module main(
input clk, rst, SSDClk, input [1:0] LEDSel, input [3:0] SSDSel,     
output reg [15:0] LED, output reg [12:0] SSD
    );
wire [31:0] PC_input;
wire [31:0] PC;
wire [31:0] PC_Add4;
wire [31:0] PC_Branch;
Register #(32) ProgramCounter(.clk(clk), .load(1'b1), .rst(rst), .D(PC_input), .Q(PC));


//Instruction Fetching
wire [31:0] IF_data;
InstrMem InstructionMemory(.addr(PC[7:2]),.data_out(IF_data));

//Constrol Signals
wire branchSignal, memoryReadSignal, memroyToRegisterSignal, memoryWriteSignal, 
                ALUSourceSignal, registerWriteSignal, jumpSignal;
wire [1:0] ALUOpSignal;
control ControlSignals(.instr(IF_data), .branch(branchSignal), .jump(jumpSignal),
                        .memRead(memoryReadSignal), .MemtoReg(memroyToRegisterSignal), .MemWrite(memoryWriteSignal),
                        .ALUSrc(ALUSourceSignal), .RegWrite(registerWriteSignal), .ALUOp(ALUOpSignal) );
//Instruction Decoding
wire [31:0] dataWrite, data_rs1, data_rs2;
RegisterFile RF(.clk(clk), .rst(rst), .regWrite(registerWriteSignal), 
                .rs1(IF_data[19:15]), .rs2(IF_data[24:20]), .rd(IF_data[11:7]),
                .writeData(dataWrite), .data1(data_rs1), .data2(data_rs2));
//Immediate generator
wire [31:0] Immediate;
ImmGen ImmediateGenerator(.instr(IF_data), .imm(Immediate));


//ALU Control
wire [3:0] ALUSelector;
ALU_control ALUC(.ALUop(ALUOpSignal), .instr(IF_data), .ALUsel(ALUSelector));

//ALU
wire [4:0] shamt = IF_data[24:20];
wire [31:0] secondValue;
wire zeroSignal, carrySignal, zeroSignal, overflowSignal, signSignal;
wire [31:0] ALUResult;
nMUX #(32) mux(.sel(ALUSourceSignal), .a(data_rs2), .b(Immediate), .c(secondValue));
prv32_ALU alu (
    .a(data_rs1),
    .b(secondValue),
    .shamt(shamt),
    .alufn(ALUSelector),       // ALUOp
    .r(ALUResult),
    .cf(carrySignal),
    .zf(zeroSignal),
    .vf(overflowSignal),
    .sf(signSignal)
);
//Branch address logic
wire [31:0] PreShiftImmediate;
assign PreShiftImmediate = {Immediate[31], Immediate[31:1]};
wire [31:0] ImmediateShifted;
wire BranchConfirm;
assign BranchConfirm = (branchSignal & zeroSignal);


// Memory
wire [5:0] MemoryAddress;
wire [31:0] MemoryOutput;
assign MemoryAddress = ALUResult[7:2];
DataMem DataMemory(.clk(clk), .MemRead(memoryReadSignal), .MemWrite(memoryWriteSignal),
                    .addr(MemoryAddress), .data_in(data_rs2), .data_out(MemoryOutput));

//Data Write result
nMUX #(32) mux2(.sel(memoryToRegisterSignal), .a(ALUResult), .b(MemoryOutput), .c(dataWrite));


//Branch decisions
assign PC_Add4 = PC+32'd4;
assign PC_Branch = PC + ImmediateShifted;
nMUX #(32) BranchMux(.sel(BranchConfirm), .a(PC_Add4), .b(PC_Branch), .c(PC_input));

//Concatenation of control signals
wire [15:0] controlSignalsCombined;
assign controlSignalsCombined = { 2'b00, branchSignal, memoryReadSignal, memroyToRegisterSignal, memoryWriteSignal, 
                ALUSourceSignal, registerWriteSignal, ALUOpSignal, ALUSelector, zeroSignal, BranchConfirm};

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
            SSD = ImmediateShifted[12:0];
        end
        4'b1001: begin
            SSD = secondValue[12:0];
        end
        4'b1010: begin
            SSD = ALUResult[12:0];
        end
        4'b1011: begin
            SSD = MemoryOutput[12:0];
        end
        
    endcase
end
endmodule
