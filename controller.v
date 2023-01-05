`timescale 1ns / 1ps
`include "define_instr_dec.vh"
`include "define_alu_control.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,rst,
	//decode stage
	input wire [31:0] instrD,
	output wire pcsrcD,branchD,equalD,jumpD,
	output wire is_IMM,
	//execute stage
	input wire flushE,stallE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,
	output wire[4:0] alucontrolE,
	output wire mfhiE,mfloE,
	output wire [1:0]hi_mdrE,lo_mdrE,
	//mem stage
	output wire memtoregM,memwriteM,
				regwriteM,hi_writeM,lo_writeM,hi_to_regM,lo_to_regM,
	//write back stage
	output wire memtoregW,regwriteW,hi_writeW,lo_writeW
    );
	
	//decode stage
	wire memtoregD,memwriteD,alusrcD,
		 regdstD,regwriteD;
	wire hi_writeD,lo_writeD;
	wire hi_to_regD; //是否将hilo中数据写入寄存器
	wire lo_to_regD;
	wire mfhiD,mfloD;
	wire [1:0] hi_mdrD,lo_mdrD;
	wire[4:0] alucontrolD;

	//execute stage
	wire memwriteE;
	wire hilo_writeE;
	wire hi_to_regE;
	wire lo_to_regE;
	maindec md(
		instrD,
		memtoregD,memwriteD,
		branchD,alusrcD,
		regdstD,regwriteD,
		jumpD,
		is_IMM,
		hi_writeD,lo_writeD,
		mfhiD,mfloD,
		hi_mdrD,lo_mdrD,
		hi_to_regD,
		lo_to_regD
		);
	aludec ad(instrD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	floprc #(20) regE(
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,hi_writeD,lo_writeD,hi_to_regD,lo_to_regD,hi_mdrD,lo_mdrD,mfhiD,mfloD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,hi_writeE,lo_writeE,hi_to_regE,lo_to_regE,hi_mdrE,lo_mdrE,mfhiE,mfloE}
		);
	flopr #(9) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE,hi_writeE,lo_writeE,hi_to_regE,lo_to_regE},
		{memtoregM,memwriteM,regwriteM,hi_writeM,lo_writeM,hi_to_regM,lo_to_regM}
		);
	flopr #(9) regW(
		clk,rst,
		{memtoregM,regwriteM,hi_writeM,lo_writeM},
		{memtoregW,regwriteW,hi_writeW,lo_writeW}
		);
endmodule