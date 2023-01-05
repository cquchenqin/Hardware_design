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
	input wire flushE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,
	output wire[4:0] alucontrolE,

	//mem stage
	output wire memtoregM,memwriteM,
				regwriteM,hilo_writeM,hi_to_regM,lo_to_regM,
	//write back stage
	output wire memtoregW,regwriteW,hilo_writeW

    );
	
	//decode stage
	wire memtoregD,memwriteD,alusrcD,
		regdstD,regwriteD;
	wire hilo_writeD;
	wire hi_to_regD; //是否将hilo中数据写入寄存器
	wire lo_to_regD;
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
		hilo_writeD,
		hi_to_regD,
		lo_to_regD
		);
	aludec ad(instrD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	floprc #(13) regE(
		clk,
		rst,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,hilo_writeD,hi_to_regD,lo_to_regD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,hilo_writeE,hi_to_regE,lo_to_regE}
		);
	flopr #(8) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE,hilo_writeE,hi_to_regE,lo_to_regE},
		{memtoregM,memwriteM,regwriteM,hilo_writeM,hi_to_regM,lo_to_regM}
		);
	flopr #(8) regW(
		clk,rst,
		{memtoregM,regwriteM,hilo_writeM},
		{memtoregW,regwriteW,hilo_writeW}
		);
endmodule
