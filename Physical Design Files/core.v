module ALU (
	SrcAE,
	SrcBE,
	ALUControlE,
	ALUResultE,
	Z,
	OV,
	CY,
	N
);
	reg _sv2v_0;
	input wire [31:0] SrcAE;
	input wire [31:0] SrcBE;
	input wire [3:0] ALUControlE;
	output reg [31:0] ALUResultE;
	output wire Z;
	output wire OV;
	output wire CY;
	output wire N;
	wire sub;
	wire [31:0] bx;
	wire [32:0] t;
	wire [31:0] sum;
	wire eq;
	wire lts;
	wire ltu;
	assign sub = ALUControlE == 4'b0001;
	assign bx = SrcBE ^ {32 {sub}};
	assign t = {SrcAE, 1'b1} + {bx, sub};
	assign sum = t[32:1];
	assign eq = SrcAE == SrcBE;
	assign lts = $signed(SrcAE) < $signed(SrcBE);
	assign ltu = SrcAE < SrcBE;
	always @(*) begin
		if (_sv2v_0)
			;
		case (ALUControlE)
			4'b0000: ALUResultE = sum;
			4'b0001: ALUResultE = sum;
			4'b0010: ALUResultE = SrcAE << SrcBE[4:0];
			4'b0011: ALUResultE = {31'b0000000000000000000000000000000, lts};
			4'b0100: ALUResultE = {31'b0000000000000000000000000000000, ltu};
			4'b0101: ALUResultE = SrcAE ^ SrcBE;
			4'b0110: ALUResultE = SrcAE >> SrcBE[4:0];
			4'b0111: ALUResultE = $signed(SrcAE) >>> SrcBE[4:0];
			4'b1000: ALUResultE = SrcAE | SrcBE;
			4'b1001: ALUResultE = SrcAE & SrcBE;
			default: ALUResultE = 32'b00000000000000000000000000000000;
		endcase
	end
	assign Z = eq;
	assign N = lts;
	assign OV = 1'b0;
	assign CY = ~ltu;
	initial _sv2v_0 = 0;
endmodule
module ALUDecoder (
	ALUOp,
	funct3D,
	funct7b5D,
	ALUControlE
);
	reg _sv2v_0;
	input wire [1:0] ALUOp;
	input wire [2:0] funct3D;
	input wire funct7b5D;
	output reg [3:0] ALUControlE;
	always @(*) begin
		if (_sv2v_0)
			;
		case (ALUOp)
			2'b00: ALUControlE = 4'b0000;
			2'b01: ALUControlE = 4'b0001;
			default:
				case (funct3D)
					3'b000:
						if (funct7b5D == 1'b0)
							ALUControlE = 4'b0000;
						else
							ALUControlE = 4'b0001;
					3'b001: ALUControlE = 4'b0010;
					3'b010: ALUControlE = 4'b0011;
					3'b011: ALUControlE = 4'b0100;
					3'b100: ALUControlE = 4'b0101;
					3'b101:
						if (funct7b5D == 1'b0)
							ALUControlE = 4'b0110;
						else
							ALUControlE = 4'b0111;
					3'b110: ALUControlE = 4'b1000;
					3'b111: ALUControlE = 4'b1001;
					default: ALUControlE = 4'bzzzz;
				endcase
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module Adder (
	a,
	b,
	c
);
	input wire [31:0] a;
	input wire [31:0] b;
	output wire [31:0] c;
	assign c = a + b;
endmodule
module Controller (
	OpD,
	funct3D,
	funct7b5D,
	JumpE,
	BranchE,
	funct3E,
	Z,
	OV,
	CY,
	N,
	RegWriteD,
	ResultSrcD,
	MemWriteD,
	JumpD,
	BranchD,
	ALUControlD,
	ALUSrcD,
	ImmSrcD,
	PCSrcE
);
	reg _sv2v_0;
	input wire [6:0] OpD;
	input wire [2:0] funct3D;
	input wire funct7b5D;
	input wire JumpE;
	input wire BranchE;
	input wire [2:0] funct3E;
	input wire Z;
	input wire OV;
	input wire CY;
	input wire N;
	output wire RegWriteD;
	output wire [2:0] ResultSrcD;
	output wire MemWriteD;
	output wire JumpD;
	output wire BranchD;
	output wire [3:0] ALUControlD;
	output wire ALUSrcD;
	output wire [2:0] ImmSrcD;
	output reg [1:0] PCSrcE;
	wire [1:0] ALUOpD;
	MainDecoder MainDec(
		.Op(OpD),
		.funct3D(funct3D),
		.RegWriteD(RegWriteD),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.JumpD(JumpD),
		.BranchD(BranchD),
		.ALUOp(ALUOpD),
		.ALUSrcD(ALUSrcD),
		.ImmSrcD(ImmSrcD)
	);
	ALUDecoder ALUDec(
		.ALUOp(ALUOpD),
		.funct3D(funct3D),
		.funct7b5D(funct7b5D),
		.ALUControlE(ALUControlD)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		if (JumpE & (OpD == 7'd103))
			PCSrcE = 2'b10;
		else
			case (funct3E)
				3'b000: PCSrcE = ((Z & BranchE) | JumpE ? 2'b01 : 2'b00);
				3'b001: PCSrcE = ((~Z & BranchE) | JumpE ? 2'b01 : 2'b00);
				3'b100: PCSrcE = (((OV ^ N) & BranchE) | JumpE ? 2'b01 : 2'b00);
				3'b101: PCSrcE = ((~(OV ^ N) & BranchE) | JumpE ? 2'b01 : 2'b00);
				3'b110: PCSrcE = ((~CY & BranchE) | JumpE ? 2'b01 : 2'b00);
				3'b111: PCSrcE = ((CY & BranchE) | JumpE ? 2'b01 : 2'b00);
				default: PCSrcE = 2'b00;
			endcase
	end
	initial _sv2v_0 = 0;
endmodule
module DataMem (
	ALUResultM,
	WriteDataM,
	WE,
	funct3M,
	clk,
	ReadDataM
);
	reg _sv2v_0;
	input wire [31:0] ALUResultM;
	input wire [31:0] WriteDataM;
	input wire WE;
	input wire [2:0] funct3M;
	input wire clk;
	output reg [31:0] ReadDataM;
	reg [31:0] mem [63:0];
	always @(*) begin
		if (_sv2v_0)
			;
		case (funct3M)
			3'b000: ReadDataM = {{24 {mem[ALUResultM[31:2]][7]}}, mem[ALUResultM[31:2]][7:0]};
			3'b001: ReadDataM = {{16 {mem[ALUResultM[31:2]][15]}}, mem[ALUResultM[31:2]][15:0]};
			3'b010: ReadDataM = mem[ALUResultM[31:2]];
			3'b100: ReadDataM = {24'b000000000000000000000000, mem[ALUResultM[31:2]][7:0]};
			3'b101: ReadDataM = {16'b0000000000000000, mem[ALUResultM[31:2]][15:0]};
			default: ReadDataM = 32'b00000000000000000000000000000000;
		endcase
	end
	always @(posedge clk)
		if (WE)
			case (funct3M)
				3'b000: mem[ALUResultM[31:2]][7:0] <= WriteDataM[7:0];
				3'b001: mem[ALUResultM[31:2]][15:0] <= WriteDataM[15:0];
				3'b010: mem[ALUResultM[31:2]] <= WriteDataM;
				default: mem[ALUResultM[31:2]] <= 32'b00000000000000000000000000000000;
			endcase
	initial _sv2v_0 = 0;
endmodule
module Datapath (
	RegWriteD,
	ResultSrcD,
	MemWriteD,
	JumpD,
	BranchD,
	ALUControlD,
	ALUSrcD,
	ImmSrcD,
	PCSrcE,
	ForwardAE,
	ForwardBE,
	StallF,
	StallD,
	FlushD,
	FlushE,
	InstrF,
	ReadDataM,
	clk,
	reset,
	OpD,
	funct3D,
	funct7b5D,
	Z,
	CY,
	OV,
	N,
	JumpE,
	BranchE,
	funct3E,
	Rs1D,
	Rs2D,
	Rs1E,
	Rs2E,
	RdE,
	RdM,
	RdW,
	ResultSrcE0,
	RegWriteM,
	RegWriteW,
	PCF,
	funct3M,
	MemWriteM,
	ALUResultM,
	WriteDataM,
	ResultW,
	WriteDataW
);
	input wire RegWriteD;
	input wire [2:0] ResultSrcD;
	input wire MemWriteD;
	input wire JumpD;
	input wire BranchD;
	input wire [3:0] ALUControlD;
	input wire ALUSrcD;
	input wire [2:0] ImmSrcD;
	input wire [1:0] PCSrcE;
	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE;
	input wire StallF;
	input wire StallD;
	input wire FlushD;
	input wire FlushE;
	input wire [31:0] InstrF;
	input wire [31:0] ReadDataM;
	input wire clk;
	input wire reset;
	output wire [6:0] OpD;
	output wire [2:0] funct3D;
	output wire funct7b5D;
	output wire Z;
	output wire CY;
	output wire OV;
	output wire N;
	output wire JumpE;
	output wire BranchE;
	output wire [2:0] funct3E;
	output wire [4:0] Rs1D;
	output wire [4:0] Rs2D;
	output wire [4:0] Rs1E;
	output wire [4:0] Rs2E;
	output wire [4:0] RdE;
	output wire [4:0] RdM;
	output wire [4:0] RdW;
	output wire ResultSrcE0;
	output wire RegWriteM;
	output wire RegWriteW;
	output wire [31:0] PCF;
	output wire [2:0] funct3M;
	output wire MemWriteM;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	output wire [31:0] ResultW;
	output wire [31:0] WriteDataW;
	wire [31:0] PCTargetE;
	wire [31:0] ALUResultE;
	wire [31:0] PCPlus4F;
	Fetch_Stage FS(
		.PCSrcE(PCSrcE),
		.StallF(StallF),
		.clk(clk),
		.reset(reset),
		.PCTargetE(PCTargetE),
		.ALUResultE(ALUResultE),
		.PCF(PCF),
		.PCPlus4F(PCPlus4F)
	);
	wire [31:0] RD1D;
	wire [31:0] RD2D;
	wire [31:0] PCD;
	wire [4:0] RdD;
	wire [31:0] ImmExtD;
	wire [31:0] PCPlus4D;
	Decode_Stage DS(
		.ImmSrcD(ImmSrcD),
		.clk(clk),
		.StallD(StallD),
		.FlushD(FlushD),
		.InstrF(InstrF),
		.PCF(PCF),
		.PCPlus4F(PCPlus4F),
		.RdW(RdW),
		.ResultW(ResultW),
		.RegWriteW(RegWriteW),
		.OpD(OpD),
		.funct3D(funct3D),
		.funct7b5D(funct7b5D),
		.RD1D(RD1D),
		.RD2D(RD2D),
		.PCD(PCD),
		.Rs1D(Rs1D),
		.Rs2D(Rs2D),
		.RdD(RdD),
		.ImmExtD(ImmExtD),
		.PCPlus4D(PCPlus4D)
	);
	wire RegWriteE;
	wire [2:0] ResultSrcE;
	wire MemWriteE;
	wire [31:0] WriteDataE;
	wire [31:0] ImmExtE;
	wire [31:0] PCPlus4E;
	Execution_Stage ES(
		.RegWriteD(RegWriteD),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.JumpD(JumpD),
		.BranchD(BranchD),
		.ALUControlD(ALUControlD),
		.ALUSrcD(ALUSrcD),
		.funct3D(funct3D),
		.RD1D(RD1D),
		.RD2D(RD2D),
		.PCD(PCD),
		.Rs1D(Rs1D),
		.Rs2D(Rs2D),
		.RdD(RdD),
		.ImmExtD(ImmExtD),
		.PCPlus4D(PCPlus4D),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.FlushE(FlushE),
		.clk(clk),
		.ALUResultM(ALUResultM),
		.ResultW(ResultW),
		.RegWriteE(RegWriteE),
		.ResultSrcE(ResultSrcE),
		.MemWriteE(MemWriteE),
		.JumpE(JumpE),
		.BranchE(BranchE),
		.funct3E(funct3E),
		.Z(Z),
		.OV(OV),
		.CY(CY),
		.N(N),
		.ResultSrcE0(ResultSrcE0),
		.Rs1E(Rs1E),
		.Rs2E(Rs2E),
		.ALUResultE(ALUResultE),
		.WriteDataE(WriteDataE),
		.PCTargetE(PCTargetE),
		.RdE(RdE),
		.ImmExtE(ImmExtE),
		.PCPlus4E(PCPlus4E)
	);
	wire [2:0] ResultSrcM;
	wire [31:0] PCTargetM;
	wire [31:0] ImmExtM;
	wire [31:0] PCPlus4M;
	Memory_Stage MS(
		.RegWriteE(RegWriteE),
		.ResultSrcE(ResultSrcE),
		.MemWriteE(MemWriteE),
		.funct3E(funct3E),
		.ALUResultE(ALUResultE),
		.WriteDataE(WriteDataE),
		.PCTargetE(PCTargetE),
		.RdE(RdE),
		.PCPlus4E(PCPlus4E),
		.ImmExtE(ImmExtE),
		.clk(clk),
		.RegWriteM(RegWriteM),
		.ResultSrcM(ResultSrcM),
		.MemWriteM(MemWriteM),
		.funct3M(funct3M),
		.ALUResultM(ALUResultM),
		.WriteDataM(WriteDataM),
		.PCTargetM(PCTargetM),
		.RdM(RdM),
		.PCPlus4M(PCPlus4M),
		.ImmExtM(ImmExtM)
	);
	WriteBack_Stage WBS(
		.RegWriteM(RegWriteM),
		.ResultSrcM(ResultSrcM),
		.clk(clk),
		.ALUResultM(ALUResultM),
		.ReadDataM(ReadDataM),
		.WriteDataM(WriteDataM),
		.PCTargetM(PCTargetM),
		.RdM(RdM),
		.PCPlus4M(PCPlus4M),
		.ImmExtM(ImmExtM),
		.RegWriteW(RegWriteW),
		.ResultW(ResultW),
		.WriteDataW(WriteDataW),
		.RdW(RdW)
	);
endmodule
module Decode_Execute_Reg (
	RegWriteD,
	ResultSrcD,
	MemWriteD,
	JumpD,
	BranchD,
	ALUControlD,
	ALUSrcD,
	funct3D,
	RD1D,
	RD2D,
	PCD,
	Rs1D,
	Rs2D,
	RdD,
	ImmExtD,
	PCPlus4D,
	clk,
	FlushE,
	RegWriteE,
	ResultSrcE,
	MemWriteE,
	JumpE,
	BranchE,
	ALUControlE,
	ALUSrcE,
	funct3E,
	RD1E,
	RD2E,
	PCE,
	Rs1E,
	Rs2E,
	RdE,
	ImmExtE,
	PCPlus4E
);
	input wire RegWriteD;
	input wire [2:0] ResultSrcD;
	input wire MemWriteD;
	input wire JumpD;
	input wire BranchD;
	input wire [3:0] ALUControlD;
	input wire ALUSrcD;
	input wire [2:0] funct3D;
	input wire [31:0] RD1D;
	input wire [31:0] RD2D;
	input wire [31:0] PCD;
	input wire [4:0] Rs1D;
	input wire [4:0] Rs2D;
	input wire [4:0] RdD;
	input wire [31:0] ImmExtD;
	input wire [31:0] PCPlus4D;
	input wire clk;
	input wire FlushE;
	output reg RegWriteE;
	output reg [2:0] ResultSrcE;
	output reg MemWriteE;
	output reg JumpE;
	output reg BranchE;
	output reg [3:0] ALUControlE;
	output reg ALUSrcE;
	output reg [2:0] funct3E;
	output reg [31:0] RD1E;
	output reg [31:0] RD2E;
	output reg [31:0] PCE;
	output reg [4:0] Rs1E;
	output reg [4:0] Rs2E;
	output reg [4:0] RdE;
	output reg [31:0] ImmExtE;
	output reg [31:0] PCPlus4E;
	always @(posedge clk) begin
		RdE <= RdD;
		ImmExtE <= ImmExtD;
		PCPlus4E <= PCPlus4D;
		PCE <= PCD;
		if (FlushE) begin
			RegWriteE <= 0;
			ResultSrcE <= 0;
			MemWriteE <= 0;
			JumpE <= 0;
			BranchE <= 0;
			ALUControlE <= 0;
			ALUSrcE <= 0;
			funct3E <= 0;
			RD1E <= 0;
			RD2E <= 0;
			Rs1E <= 0;
			Rs2E <= 0;
		end
		else begin
			RegWriteE <= RegWriteD;
			ResultSrcE <= ResultSrcD;
			MemWriteE <= MemWriteD;
			JumpE <= JumpD;
			BranchE <= BranchD;
			ALUControlE <= ALUControlD;
			ALUSrcE <= ALUSrcD;
			funct3E <= funct3D;
			RD1E <= RD1D;
			RD2E <= RD2D;
			Rs1E <= Rs1D;
			Rs2E <= Rs2D;
		end
	end
endmodule
module Decode_Stage (
	ImmSrcD,
	clk,
	StallD,
	FlushD,
	InstrF,
	PCF,
	PCPlus4F,
	RdW,
	ResultW,
	RegWriteW,
	OpD,
	funct3D,
	funct7b5D,
	RD1D,
	RD2D,
	PCD,
	Rs1D,
	Rs2D,
	RdD,
	ImmExtD,
	PCPlus4D
);
	input wire [2:0] ImmSrcD;
	input wire clk;
	input wire StallD;
	input wire FlushD;
	input wire [31:0] InstrF;
	input wire [31:0] PCF;
	input wire [31:0] PCPlus4F;
	input wire [4:0] RdW;
	input wire [31:0] ResultW;
	input wire RegWriteW;
	output wire [6:0] OpD;
	output wire [2:0] funct3D;
	output wire funct7b5D;
	output wire [31:0] RD1D;
	output wire [31:0] RD2D;
	output wire [31:0] PCD;
	output wire [4:0] Rs1D;
	output wire [4:0] Rs2D;
	output wire [4:0] RdD;
	output wire [31:0] ImmExtD;
	output wire [31:0] PCPlus4D;
	wire [31:0] InstrD;
	Fetch_Decode_Reg FDReg(
		.clk(clk),
		.StallD(StallD),
		.FlushD(FlushD),
		.InstrF(InstrF),
		.PCF(PCF),
		.PCPlus4F(PCPlus4F),
		.InstrD(InstrD),
		.PCD(PCD),
		.PCPlus4D(PCPlus4D)
	);
	RegFile RegisterFile(
		.A1D(Rs1D),
		.A2D(Rs2D),
		.A3D(RdW),
		.WD3D(ResultW),
		.WE3W(RegWriteW),
		.clk(clk),
		.RD1D(RD1D),
		.RD2D(RD2D)
	);
	SignExt ExtUnit(
		.ImmSrcD(ImmSrcD),
		.InstrD(InstrD[31:7]),
		.ImmExtD(ImmExtD)
	);
	assign OpD = InstrD[6:0];
	assign funct3D = InstrD[14:12];
	assign funct7b5D = InstrD[30];
	assign Rs1D = InstrD[19:15];
	assign Rs2D = InstrD[24:20];
	assign RdD = InstrD[11:7];
endmodule
module Execute_Memory_Reg (
	RegWriteE,
	ResultSrcE,
	MemWriteE,
	funct3E,
	ALUResultE,
	WriteDataE,
	PCTargetE,
	RdE,
	ImmExtE,
	PCPlus4E,
	clk,
	RegWriteM,
	ResultSrcM,
	MemWriteM,
	funct3M,
	ALUResultM,
	WriteDataM,
	PCTargetM,
	RdM,
	ImmExtM,
	PCPlus4M
);
	input wire RegWriteE;
	input wire [2:0] ResultSrcE;
	input wire MemWriteE;
	input wire [2:0] funct3E;
	input wire [31:0] ALUResultE;
	input wire [31:0] WriteDataE;
	input wire [31:0] PCTargetE;
	input wire [4:0] RdE;
	input wire [31:0] ImmExtE;
	input wire [31:0] PCPlus4E;
	input wire clk;
	output reg RegWriteM;
	output reg [2:0] ResultSrcM;
	output reg MemWriteM;
	output reg [2:0] funct3M;
	output reg [31:0] ALUResultM;
	output reg [31:0] WriteDataM;
	output reg [31:0] PCTargetM;
	output reg [4:0] RdM;
	output reg [31:0] ImmExtM;
	output reg [31:0] PCPlus4M;
	always @(posedge clk) begin
		RegWriteM <= RegWriteE;
		ResultSrcM <= ResultSrcE;
		MemWriteM <= MemWriteE;
		funct3M <= funct3E;
		ALUResultM <= ALUResultE;
		WriteDataM <= WriteDataE;
		PCTargetM <= PCTargetE;
		RdM <= RdE;
		ImmExtM <= ImmExtE;
		PCPlus4M <= PCPlus4E;
	end
endmodule
module Execution_Stage (
	RegWriteD,
	ResultSrcD,
	MemWriteD,
	JumpD,
	BranchD,
	ALUControlD,
	ALUSrcD,
	funct3D,
	RD1D,
	RD2D,
	PCD,
	Rs1D,
	Rs2D,
	RdD,
	ImmExtD,
	PCPlus4D,
	ForwardAE,
	ForwardBE,
	FlushE,
	clk,
	ALUResultM,
	ResultW,
	RegWriteE,
	ResultSrcE,
	MemWriteE,
	JumpE,
	BranchE,
	funct3E,
	Z,
	OV,
	CY,
	N,
	ResultSrcE0,
	Rs1E,
	Rs2E,
	ALUResultE,
	WriteDataE,
	PCTargetE,
	RdE,
	ImmExtE,
	PCPlus4E
);
	input wire RegWriteD;
	input wire [3:0] ResultSrcD;
	input wire MemWriteD;
	input wire JumpD;
	input wire BranchD;
	input wire [3:0] ALUControlD;
	input wire ALUSrcD;
	input wire [2:0] funct3D;
	input wire [31:0] RD1D;
	input wire [31:0] RD2D;
	input wire [31:0] PCD;
	input wire [4:0] Rs1D;
	input wire [4:0] Rs2D;
	input wire [4:0] RdD;
	input wire [31:0] ImmExtD;
	input wire [31:0] PCPlus4D;
	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE;
	input wire FlushE;
	input wire clk;
	input wire [31:0] ALUResultM;
	input wire [31:0] ResultW;
	output wire RegWriteE;
	output wire [3:0] ResultSrcE;
	output wire MemWriteE;
	output wire JumpE;
	output wire BranchE;
	output wire [2:0] funct3E;
	output wire Z;
	output wire OV;
	output wire CY;
	output wire N;
	output wire ResultSrcE0;
	output wire [4:0] Rs1E;
	output wire [4:0] Rs2E;
	output wire [31:0] ALUResultE;
	output wire [31:0] WriteDataE;
	output wire [31:0] PCTargetE;
	output wire [4:0] RdE;
	output wire [31:0] ImmExtE;
	output wire [31:0] PCPlus4E;
	wire [3:0] ALUControlE;
	wire ALUSrcE;
	wire [31:0] RD1E;
	wire [31:0] RD2E;
	wire [31:0] PCE;
	Decode_Execute_Reg DEReg(
		.RegWriteD(RegWriteD),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.JumpD(JumpD),
		.BranchD(BranchD),
		.ALUControlD(ALUControlD),
		.ALUSrcD(ALUSrcD),
		.funct3D(funct3D),
		.RD1D(RD1D),
		.RD2D(RD2D),
		.PCD(PCD),
		.Rs1D(Rs1D),
		.Rs2D(Rs2D),
		.RdD(RdD),
		.ImmExtD(ImmExtD),
		.PCPlus4D(PCPlus4D),
		.clk(clk),
		.FlushE(FlushE),
		.RegWriteE(RegWriteE),
		.ResultSrcE(ResultSrcE),
		.MemWriteE(MemWriteE),
		.JumpE(JumpE),
		.BranchE(BranchE),
		.ALUControlE(ALUControlE),
		.ALUSrcE(ALUSrcE),
		.funct3E(funct3E),
		.RD1E(RD1E),
		.RD2E(RD2E),
		.PCE(PCE),
		.Rs1E(Rs1E),
		.Rs2E(Rs2E),
		.RdE(RdE),
		.ImmExtE(ImmExtE),
		.PCPlus4E(PCPlus4E)
	);
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	Mux3 FwdAEmux(
		.a(RD1E),
		.b(ResultW),
		.c(ALUResultM),
		.src(ForwardAE),
		.y(SrcAE)
	);
	Mux3 FwdBEmux(
		.a(RD2E),
		.b(ResultW),
		.c(ALUResultM),
		.src(ForwardBE),
		.y(WriteDataE)
	);
	Mux2 ALUmux(
		.a(WriteDataE),
		.b(ImmExtE),
		.src(ALUSrcE),
		.y(SrcBE)
	);
	Adder PCTargetAdd(
		.a(PCE),
		.b(ImmExtE),
		.c(PCTargetE)
	);
	ALU ALUunit(
		.SrcAE(SrcAE),
		.SrcBE(SrcBE),
		.ALUControlE(ALUControlE),
		.ALUResultE(ALUResultE),
		.Z(Z),
		.OV(OV),
		.CY(CY),
		.N(N)
	);
	assign ResultSrcE0 = ResultSrcE[0];
endmodule
module Fetch_Decode_Reg (
	clk,
	StallD,
	FlushD,
	InstrF,
	PCF,
	PCPlus4F,
	InstrD,
	PCD,
	PCPlus4D
);
	input wire clk;
	input wire StallD;
	input wire FlushD;
	input wire [31:0] InstrF;
	input wire [31:0] PCF;
	input wire [31:0] PCPlus4F;
	output reg [31:0] InstrD;
	output reg [31:0] PCD;
	output reg [31:0] PCPlus4D;
	always @(posedge clk) begin
		if (FlushD)
			InstrD <= 32'b00000000000000000000000000000000;
		else if (~StallD)
			InstrD <= InstrF;
		if (~StallD) begin
			PCD <= PCF;
			PCPlus4D <= PCPlus4F;
		end
	end
endmodule
module Fetch_Stage (
	PCSrcE,
	StallF,
	clk,
	reset,
	PCTargetE,
	ALUResultE,
	PCF,
	PCPlus4F
);
	input wire [1:0] PCSrcE;
	input wire StallF;
	input wire clk;
	input wire reset;
	input wire [31:0] PCTargetE;
	input wire [31:0] ALUResultE;
	output wire [31:0] PCF;
	output wire [31:0] PCPlus4F;
	wire [31:0] PCNextF;
	Mux3 PCNextFMux(
		.a(PCPlus4F),
		.b(PCTargetE),
		.c(ALUResultE),
		.src(PCSrcE),
		.y(PCNextF)
	);
	PC ProgCount(
		.PCNextF(PCNextF),
		.clk(clk),
		.StallF(StallF),
		.reset(reset),
		.PCF(PCF)
	);
	Adder PCPlus4(
		.a(PCF),
		.b(32'h00000004),
		.c(PCPlus4F)
	);
endmodule
module HazardUnit (
	reset,
	Rs1E,
	Rs2E,
	RdM,
	RdW,
	RegWriteM,
	RegWriteW,
	ForwardAE,
	ForwardBE,
	ResultSrcE0,
	Rs1D,
	Rs2D,
	RdE,
	StallF,
	StallD,
	PCSrcE,
	FlushD,
	FlushE
);
	reg _sv2v_0;
	input wire reset;
	input wire [4:0] Rs1E;
	input wire [4:0] Rs2E;
	input wire [4:0] RdM;
	input wire [4:0] RdW;
	input wire RegWriteM;
	input wire RegWriteW;
	output reg [1:0] ForwardAE;
	output reg [1:0] ForwardBE;
	input wire ResultSrcE0;
	input wire [4:0] Rs1D;
	input wire [4:0] Rs2D;
	input wire [4:0] RdE;
	output wire StallF;
	output wire StallD;
	input wire [1:0] PCSrcE;
	output wire FlushD;
	output wire FlushE;
	wire rst_fwd;
	assign rst_fwd = 1'b0;
	always @(*) begin
		if (_sv2v_0)
			;
		if (rst_fwd)
			ForwardAE = 2'b00;
		else if (((Rs1E == RdM) & (Rs1E != 0)) & RegWriteM)
			ForwardAE = 2'b10;
		else if (((Rs1E == RdW) & (Rs1E != 0)) & RegWriteW)
			ForwardAE = 2'b01;
		else
			ForwardAE = 2'b00;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if (rst_fwd)
			ForwardBE = 2'b00;
		else if (((Rs2E == RdM) & (Rs2E != 0)) & RegWriteM)
			ForwardBE = 2'b10;
		else if (((Rs2E == RdW) & (Rs2E != 0)) & RegWriteW)
			ForwardBE = 2'b01;
		else
			ForwardBE = 2'b00;
	end
	wire lwStall;
	assign lwStall = (reset ? 0 : (ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE)) ? 1 : 0));
	assign StallD = (reset ? 0 : lwStall);
	assign StallF = (reset ? 0 : lwStall);
	assign FlushD = (reset ? 0 : PCSrcE != 2'b00);
	assign FlushE = (reset ? 0 : (PCSrcE != 2'b00) | lwStall);
	initial _sv2v_0 = 0;
endmodule
module InstrMem (
	PCF,
	InstrF
);
	input wire [31:0] PCF;
	output wire [31:0] InstrF;
	reg [31:0] rom_out;
	always @(*)
		case (PCF[31:2])
			30'd0: rom_out = 32'h00500113;
			30'd1: rom_out = 32'h00c00193;
			30'd2: rom_out = 32'hff718393;
			30'd3: rom_out = 32'h0023e233;
			30'd4: rom_out = 32'h0041f2b3;
			30'd5: rom_out = 32'h004282b3;
			30'd6: rom_out = 32'h02728863;
			30'd7: rom_out = 32'h0041a233;
			30'd8: rom_out = 32'h00020463;
			30'd9: rom_out = 32'h00000293;
			30'd10: rom_out = 32'h0023a233;
			30'd11: rom_out = 32'h005203b3;
			30'd12: rom_out = 32'h402383b3;
			30'd13: rom_out = 32'h0471aa23;
			30'd14: rom_out = 32'h06002103;
			30'd15: rom_out = 32'h005104b3;
			30'd16: rom_out = 32'h008001ef;
			30'd17: rom_out = 32'h00100113;
			30'd18: rom_out = 32'h00910133;
			30'd19: rom_out = 32'h0221a023;
			30'd20: rom_out = 32'h00210063;
			default: rom_out = 32'h00000013;
		endcase
	assign InstrF = rom_out;
endmodule
module MainDecoder (
	Op,
	funct3D,
	RegWriteD,
	ResultSrcD,
	MemWriteD,
	JumpD,
	BranchD,
	ALUOp,
	ALUSrcD,
	ImmSrcD
);
	reg _sv2v_0;
	input wire [6:0] Op;
	input wire [2:0] funct3D;
	output wire RegWriteD;
	output wire [2:0] ResultSrcD;
	output wire MemWriteD;
	output wire JumpD;
	output wire BranchD;
	output wire [1:0] ALUOp;
	output wire ALUSrcD;
	output wire [2:0] ImmSrcD;
	reg [12:0] controls;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Op)
			7'd3: controls = 13'b1001000001000;
			7'd19:
				if (funct3D == 3'b000)
					controls = 13'b1000000001000;
				else
					controls = 13'b1000000101000;
			7'd23: controls = 13'b1011000000011;
			7'd35: controls = 13'b0000100001001;
			7'd51: controls = 13'b1000000100zzz;
			7'd55: controls = 13'b1100000000011;
			7'd99: controls = 13'b0000001010010;
			7'd103: controls = 13'b1010010000100;
			7'd111: controls = 13'b1010010000100;
			default: controls = 13'b0000000000000;
		endcase
	end
	assign RegWriteD = controls[12];
	assign ResultSrcD = controls[11:9];
	assign MemWriteD = controls[8];
	assign JumpD = controls[7];
	assign BranchD = controls[6];
	assign ALUOp = controls[5:4];
	assign ALUSrcD = controls[3];
	assign ImmSrcD = controls[2:0];
	initial _sv2v_0 = 0;
endmodule
module Memory_Stage (
	RegWriteE,
	ResultSrcE,
	MemWriteE,
	funct3E,
	ALUResultE,
	WriteDataE,
	PCTargetE,
	RdE,
	PCPlus4E,
	ImmExtE,
	clk,
	RegWriteM,
	ResultSrcM,
	MemWriteM,
	funct3M,
	ALUResultM,
	WriteDataM,
	PCTargetM,
	RdM,
	PCPlus4M,
	ImmExtM
);
	input wire RegWriteE;
	input wire [2:0] ResultSrcE;
	input wire MemWriteE;
	input wire [2:0] funct3E;
	input wire [31:0] ALUResultE;
	input wire [31:0] WriteDataE;
	input wire [31:0] PCTargetE;
	input wire [4:0] RdE;
	input wire [31:0] PCPlus4E;
	input wire [31:0] ImmExtE;
	input wire clk;
	output wire RegWriteM;
	output wire [2:0] ResultSrcM;
	output wire MemWriteM;
	output wire [2:0] funct3M;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	output wire [31:0] PCTargetM;
	output wire [4:0] RdM;
	output wire [31:0] PCPlus4M;
	output wire [31:0] ImmExtM;
	Execute_Memory_Reg EMReg(
		.RegWriteE(RegWriteE),
		.ResultSrcE(ResultSrcE),
		.MemWriteE(MemWriteE),
		.funct3E(funct3E),
		.ALUResultE(ALUResultE),
		.WriteDataE(WriteDataE),
		.PCTargetE(PCTargetE),
		.RdE(RdE),
		.ImmExtE(ImmExtE),
		.PCPlus4E(PCPlus4E),
		.clk(clk),
		.RegWriteM(RegWriteM),
		.ResultSrcM(ResultSrcM),
		.MemWriteM(MemWriteM),
		.funct3M(funct3M),
		.ALUResultM(ALUResultM),
		.WriteDataM(WriteDataM),
		.PCTargetM(PCTargetM),
		.RdM(RdM),
		.ImmExtM(ImmExtM),
		.PCPlus4M(PCPlus4M)
	);
endmodule
module Memory_WriteB_Reg (
	RegWriteM,
	ResultSrcM,
	clk,
	ALUResultM,
	ReadDataM,
	WriteDataM,
	PCTargetM,
	RdM,
	ImmExtM,
	PCPlus4M,
	RegWriteW,
	ResultSrcW,
	ALUResultW,
	ReadDataW,
	WriteDataW,
	PCTargetW,
	RdW,
	ImmExtW,
	PCPlus4W
);
	input wire RegWriteM;
	input wire [2:0] ResultSrcM;
	input wire clk;
	input wire [31:0] ALUResultM;
	input wire [31:0] ReadDataM;
	input wire [31:0] WriteDataM;
	input wire [31:0] PCTargetM;
	input wire [4:0] RdM;
	input wire [31:0] ImmExtM;
	input wire [31:0] PCPlus4M;
	output reg RegWriteW;
	output reg [2:0] ResultSrcW;
	output reg [31:0] ALUResultW;
	output reg [31:0] ReadDataW;
	output reg [31:0] WriteDataW;
	output reg [31:0] PCTargetW;
	output reg [4:0] RdW;
	output reg [31:0] ImmExtW;
	output reg [31:0] PCPlus4W;
	always @(posedge clk) begin
		RegWriteW <= RegWriteM;
		ResultSrcW <= ResultSrcM;
		ALUResultW <= ALUResultM;
		ReadDataW <= ReadDataM;
		WriteDataW <= WriteDataM;
		PCTargetW <= PCTargetM;
		RdW <= RdM;
		ImmExtW <= ImmExtM;
		PCPlus4W <= PCPlus4M;
	end
endmodule
module Mux2 (
	a,
	b,
	src,
	y
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire src;
	output wire [31:0] y;
	assign y = (src ? b : a);
endmodule
module Mux3 (
	a,
	b,
	c,
	src,
	y
);
	reg _sv2v_0;
	input wire [31:0] a;
	input wire [31:0] b;
	input wire [31:0] c;
	input wire [1:0] src;
	output reg [31:0] y;
	always @(*) begin
		if (_sv2v_0)
			;
		case (src)
			2'b00: y = a;
			2'b01: y = b;
			2'b10: y = c;
			default: y = 32'b00000000000000000000000000000000;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module Mux5 (
	ALUResultW,
	ReadDataW,
	PCPlus4W,
	PCTargetW,
	ImmExtW,
	ResultSrcW,
	ResultW
);
	reg _sv2v_0;
	input wire [31:0] ALUResultW;
	input wire [31:0] ReadDataW;
	input wire [31:0] PCPlus4W;
	input wire [31:0] PCTargetW;
	input wire [31:0] ImmExtW;
	input wire [2:0] ResultSrcW;
	output reg [31:0] ResultW;
	always @(*) begin
		if (_sv2v_0)
			;
		case (ResultSrcW)
			3'b000: ResultW = ALUResultW;
			3'b001: ResultW = ReadDataW;
			3'b010: ResultW = PCPlus4W;
			3'b011: ResultW = PCTargetW;
			3'b101: ResultW = ImmExtW;
			default: ResultW = 32'b00000000000000000000000000000000;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module PC (
	PCNextF,
	clk,
	StallF,
	reset,
	PCF
);
	input wire [31:0] PCNextF;
	input wire clk;
	input wire StallF;
	input wire reset;
	output reg [31:0] PCF;
	always @(posedge clk or posedge reset)
		if (reset)
			PCF <= 32'b00000000000000000000000000000000;
		else if (~StallF)
			PCF <= PCNextF;
endmodule
module Processor (
	clk,
	reset,
	InstrF,
	ReadDataM,
	PCF,
	funct3M,
	MemWriteM,
	ALUResultM,
	WriteDataM,
	Z,
	OV,
	CY,
	N,
	ResultW,
	WriteDataW
);
	input wire clk;
	input wire reset;
	input wire [31:0] InstrF;
	input wire [31:0] ReadDataM;
	output wire [31:0] PCF;
	output wire [2:0] funct3M;
	output wire MemWriteM;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	output wire Z;
	output wire OV;
	output wire CY;
	output wire N;
	output wire [31:0] ResultW;
	output wire [31:0] WriteDataW;
	wire [6:0] OpD;
	wire [2:0] funct3D;
	wire funct7b5D;
	wire JumpE;
	wire BranchE;
	wire [2:0] funct3E;
	wire RegWriteD;
	wire [2:0] ResultSrcD;
	wire MemWriteD;
	wire JumpD;
	wire BranchD;
	wire [3:0] ALUControlD;
	wire ALUSrcD;
	wire [2:0] ImmSrcD;
	wire [1:0] PCSrcE;
	wire [1:0] ForwardAE;
	wire [1:0] ForwardBE;
	wire StallF;
	wire StallD;
	wire FlushD;
	wire FlushE;
	wire [4:0] Rs1D;
	wire [4:0] Rs2D;
	wire [4:0] Rs1E;
	wire [4:0] Rs2E;
	wire [4:0] RdE;
	wire [4:0] RdM;
	wire [4:0] RdW;
	wire ResultSrcE0;
	wire RegWriteM;
	wire RegWriteW;
	Controller con(
		.OpD(OpD),
		.funct3D(funct3D),
		.funct7b5D(funct7b5D),
		.JumpE(JumpE),
		.BranchE(BranchE),
		.funct3E(funct3E),
		.Z(Z),
		.OV(OV),
		.CY(CY),
		.N(N),
		.RegWriteD(RegWriteD),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.JumpD(JumpD),
		.BranchD(BranchD),
		.ALUControlD(ALUControlD),
		.ALUSrcD(ALUSrcD),
		.ImmSrcD(ImmSrcD),
		.PCSrcE(PCSrcE)
	);
	Datapath dp(
		.RegWriteD(RegWriteD),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.JumpD(JumpD),
		.BranchD(BranchD),
		.ALUControlD(ALUControlD),
		.ALUSrcD(ALUSrcD),
		.ImmSrcD(ImmSrcD),
		.PCSrcE(PCSrcE),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushD(FlushD),
		.FlushE(FlushE),
		.InstrF(InstrF),
		.ReadDataM(ReadDataM),
		.clk(clk),
		.reset(reset),
		.OpD(OpD),
		.funct3D(funct3D),
		.funct7b5D(funct7b5D),
		.Z(Z),
		.CY(CY),
		.OV(OV),
		.N(N),
		.JumpE(JumpE),
		.BranchE(BranchE),
		.funct3E(funct3E),
		.Rs1D(Rs1D),
		.Rs2D(Rs2D),
		.Rs1E(Rs1E),
		.Rs2E(Rs2E),
		.RdE(RdE),
		.RdM(RdM),
		.RdW(RdW),
		.ResultSrcE0(ResultSrcE0),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.PCF(PCF),
		.funct3M(funct3M),
		.MemWriteM(MemWriteM),
		.ALUResultM(ALUResultM),
		.WriteDataM(WriteDataM),
		.ResultW(ResultW),
		.WriteDataW(WriteDataW)
	);
	HazardUnit hu(
		.reset(reset),
		.Rs1E(Rs1E),
		.Rs2E(Rs2E),
		.RdM(RdM),
		.RdW(RdW),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.ResultSrcE0(ResultSrcE0),
		.Rs1D(Rs1D),
		.Rs2D(Rs2D),
		.RdE(RdE),
		.StallF(StallF),
		.StallD(StallD),
		.PCSrcE(PCSrcE),
		.FlushD(FlushD),
		.FlushE(FlushE)
	);
endmodule
module RegFile (
	A1D,
	A2D,
	A3D,
	WD3D,
	WE3W,
	clk,
	RD1D,
	RD2D
);
	input wire [4:0] A1D;
	input wire [4:0] A2D;
	input wire [4:0] A3D;
	input wire [31:0] WD3D;
	input wire WE3W;
	input wire clk;
	output wire [31:0] RD1D;
	output wire [31:0] RD2D;
	reg [31:0] ram [31:0];
	always @(negedge clk)
		if (WE3W & (A3D != 0))
			ram[A3D] <= WD3D;
	assign RD1D = ram[A1D];
	assign RD2D = ram[A2D];
endmodule
module SignExt (
	ImmSrcD,
	InstrD,
	ImmExtD
);
	reg _sv2v_0;
	input wire [2:0] ImmSrcD;
	input wire [31:7] InstrD;
	output reg [31:0] ImmExtD;
	always @(*) begin
		if (_sv2v_0)
			;
		case (ImmSrcD)
			3'b000: ImmExtD = {{20 {InstrD[31]}}, InstrD[31:20]};
			3'b001: ImmExtD = {{20 {InstrD[31]}}, InstrD[31:25], InstrD[11:7]};
			3'b010: ImmExtD = {{20 {InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0};
			3'b011: ImmExtD = {InstrD[31:12], 12'b000000000000};
			3'b100: ImmExtD = {{12 {InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0};
			default: ImmExtD = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module Top_Module (
	clk,
	reset,
	Z,
	OV,
	CY,
	N,
	ResultW,
	WriteDataW
);
	input wire clk;
	input wire reset;
	output wire Z;
	output wire OV;
	output wire CY;
	output wire N;
	output wire [31:0] ResultW;
	output wire [31:0] WriteDataW;
	wire [31:2] PCF;
	wire [31:0] InstrF;
	wire [2:0] funct3M;
	wire [31:0] ReadDataM;
	wire [31:0] WriteDataM;
	wire MemWriteM;
	wire [31:0] ALUResultM;
	Processor cpu(
		.clk(clk),
		.reset(reset),
		.InstrF(InstrF),
		.ReadDataM(ReadDataM),
		.PCF(PCF),
		.funct3M(funct3M),
		.MemWriteM(MemWriteM),
		.ALUResultM(ALUResultM),
		.WriteDataM(WriteDataM),
		.Z(Z),
		.OV(OV),
		.CY(CY),
		.N(N),
		.ResultW(ResultW),
		.WriteDataW(WriteDataW)
	);
	InstrMem im(
		.PCF(PCF),
		.InstrF(InstrF)
	);
	DataMem dm(
		.ALUResultM(ALUResultM),
		.WriteDataM(WriteDataM),
		.WE(MemWriteM),
		.funct3M(funct3M),
		.clk(clk),
		.ReadDataM(ReadDataM)
	);
endmodule
module WriteBack_Stage (
	RegWriteM,
	ResultSrcM,
	clk,
	ALUResultM,
	ReadDataM,
	WriteDataM,
	PCTargetM,
	RdM,
	PCPlus4M,
	ImmExtM,
	RegWriteW,
	ResultW,
	WriteDataW,
	RdW
);
	input wire RegWriteM;
	input wire [3:0] ResultSrcM;
	input wire clk;
	input wire [31:0] ALUResultM;
	input wire [31:0] ReadDataM;
	input wire [31:0] WriteDataM;
	input wire [31:0] PCTargetM;
	input wire [4:0] RdM;
	input wire [31:0] PCPlus4M;
	input wire [31:0] ImmExtM;
	output wire RegWriteW;
	output wire [31:0] ResultW;
	output wire [31:0] WriteDataW;
	output wire [4:0] RdW;
	wire [2:0] ResultSrcW;
	wire [31:0] ALUResultW;
	wire [31:0] ReadDataW;
	wire [31:0] PCTargetW;
	wire [31:0] ImmExtW;
	wire [31:0] PCPlus4W;
	Memory_WriteB_Reg MWReg(
		.RegWriteM(RegWriteM),
		.ResultSrcM(ResultSrcM),
		.clk(clk),
		.ALUResultM(ALUResultM),
		.ReadDataM(ReadDataM),
		.WriteDataM(WriteDataM),
		.PCTargetM(PCTargetM),
		.RdM(RdM),
		.ImmExtM(ImmExtM),
		.PCPlus4M(PCPlus4M),
		.RegWriteW(RegWriteW),
		.ResultSrcW(ResultSrcW),
		.ALUResultW(ALUResultW),
		.ReadDataW(ReadDataW),
		.WriteDataW(WriteDataW),
		.PCTargetW(PCTargetW),
		.RdW(RdW),
		.ImmExtW(ImmExtW),
		.PCPlus4W(PCPlus4W)
	);
	Mux5 ResultMux(
		.ALUResultW(ALUResultW),
		.ReadDataW(ReadDataW),
		.PCPlus4W(PCPlus4W),
		.PCTargetW(PCTargetW),
		.ImmExtW(ImmExtW),
		.ResultSrcW(ResultSrcW),
		.ResultW(ResultW)
	);
endmodule