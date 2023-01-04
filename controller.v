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
	input wire stallE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,	
	output wire[4:0] alucontrolE,

	//mem stage
	output wire memtoregM,memwriteM,
				regwriteM,hilo_writeM,
	output wire stall_divM,
	//write back stage
	output wire memtoregW,regwriteW

    );
	
	//decode stage
	wire memtoregD,memwriteD,alusrcD,
		regdstD,regwriteD;
	wire hilo_writeD;
	wire[4:0] alucontrolD;

	//execute stage
	wire memwriteE;
	wire hilo_writeE;

	maindec md(
		instrD,
		memtoregD,memwriteD,
		branchD,alusrcD,
		regdstD,regwriteD,
		jumpD,
		is_IMM,
		hilo_writeD
		);
	aludec ad(instrD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	flopenrc #(12) regE(
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,hilo_writeD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,hilo_writeE}
		);
	flopr #(10) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE,stallE,hilo_writeE},
		{memtoregM,memwriteM,regwriteM,stall_divM,hilo_writeM}
		);
	flopr #(8) regW(
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
		);
endmodule
