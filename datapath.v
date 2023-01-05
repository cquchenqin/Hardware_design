`timescale 1ns / 1ps
`include "define_instr_dec.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	output wire equalD,
	output wire [31:0] instrD,
	input wire is_IMM, //判断是否是立即数
	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire[4:0] alucontrolE,
	output wire flushE,stallE,
	input wire mfhiE,mfloE,
	input wire [1:0] hi_mdrE,lo_mdrE,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	input wire hi_writeM,lo_writeM,
	input wire hi_to_regM,
	input wire lo_to_regM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,
	input wire hi_writeW,lo_writeW
    );
	
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	wire [4:0] saD; //因SLL,SRL,SRA指令加入
	wire [5:0] functD; //div_mul加入
	//execute stage
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE,rtE,rdE;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srca3E,srcb3E;
	wire [31:0] aluoutE;
	wire [4:0] saE;
	wire [31:0] hi_inE, lo_inE;
	wire [5:0]functE;
	wire [2:0] forwardhiloE;
	//div
	wire signed_divE;
 	wire start_divE;
 	wire div_readyE;
	wire stall_divE;
	wire [63:0]div_resultE;
	//mem stage
	wire [4:0] writeregM;
	wire [31:0] hi_outM;
	wire [31:0] lo_outM;
	wire [31:0] alu_hilo_dataM;
	wire [31:0] hi_inM, lo_inM;
	//writeback stage
	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;
	wire [31:0] alu_hilo_dataW;

	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,
		//execute stage
		rsE,rtE,
		writeregE,
		regwriteE,
		memtoregE,
		forwardaE,forwardbE,
		flushE,
		stall_divE,
		stallE,
		//mf
		mfhiE,mfloE,
		forwardhiloE,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,
		hi_writeM,lo_writeM,
		//write back stage
		writeregW,
		regwriteW,
		hi_writeW,lo_writeW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD,pcnextFD);

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	pc #(32) pcreg(clk,rst,~stallF,pcnextFD,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);
	//decode stage
	flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	signext se(instrD[15:0],is_IMM,signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,equalD);

	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	assign functD = instrD[5:0];

	//execute stage
	flopenrc #(32) r1E(clk,rst,~stallE,flushE,srcaD,srcaE);
	flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcbD,srcbE);
	flopenrc #(32) r3E(clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5) r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(5) r7E(clk,rst,~stallE,flushE,saD,saE); 
	flopenrc #(6) r9E(clk,rst,~stallE,flushE,functD,functE);

	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);

	
	//乘法
	wire [63:0] mul_resultE;
	//mul mul(srca2E,srcb2E,functE,mul_resultE);

	//div 
	assign div_controlsE=(functE==`FUNC_DIV)?((div_readyE==1'b0)? 3'b111:3'b010):
						(functE==`FUNC_DIVU)?((div_readyE==1'b0)? 3'b101:3'b000):
						3'b000;
	assign {start_divE,signed_divE,stall_divE}=div_controlsE;
	div div(
		.clk(clk),
       	.rst(rst),
       	.signed_div_i(signed_divE),
       	.opdata1_i(srca2E),
       	.opdata2_i(srcb3E),
       	.start_i(start_divE),
       	.annul_i(1'b0), //固定为0 ，有异常处理时再重新确定
       	.result_o(div_resultE),
       	.ready_o(div_readyE)
	);

	//hilo
	assign hi_inE =hi_mdrE == 2'b01 ? mul_resultE[63:32]:
				   hi_mdrE == 2'b10 ? div_resultE[63:32] :
               	   hi_mdrE == 2'b11 ? srca2E :
				   32'b0;

	assign lo_inE =lo_mdrE == 2'b01 ? mul_resultE[31:0] :
                   lo_mdrE == 2'b10 ? div_resultE[31:0] :
               	   lo_mdrE == 2'b11 ? srca2E :
                   32'b0;
	
	// 如果是mf指令，则ALU A应该输入hi/lo寄存器的值，B输入的是0，前推。
	assign srca3E = forwardhiloE == 3'b000 ? srca2E :
                    forwardhiloE == 3'b001 ? hi_outM :
                    forwardhiloE == 3'b010 ? lo_outM :
                    forwardhiloE == 3'b011 ? hi_inM :
                    forwardhiloE == 3'b100 ? lo_inM :
                    forwardhiloE == 3'b101||3'b110 ? alu_hilo_dataW ://?
                    32'bx;

	alu alu(
		.a(srca3E),
		.b(srcb3E),
		.op(alucontrolE), //5'b
		.sa(saE), 
		.y(aluoutE),
		.overflow(overflow)
		);
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);

	//mem stage
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
	flopr #(32) r2M(clk,rst,aluoutE,aluoutM);
	flopr #(5) r3M(clk,rst,writeregE,writeregM);
	flopr #(64) EM_hilo (clk,rst,{hi_inE, lo_inE},{hi_inM, lo_inM});


	hilo_reg hilo(clk,rst,hi_writeM,lo_writeM,hi_inM,lo_inM,hi_outM,lo_outM);
	mux3 #(32) alu_hilomuxM(aluoutM,hi_outM,lo_outM,{lo_to_regM,hi_to_regM},alu_hilo_dataM);
	//writeback stage
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);
	flopr #(32) r4W(clk,rst,alu_hilo_dataM,alu_hilo_dataW);
	mux2 #(32) resmux(alu_hilo_dataW,readdataW,memtoregW,resultW);
endmodule