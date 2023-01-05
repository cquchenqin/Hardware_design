`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire memwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM 
    );
	
	wire [31:0] instrD;
	wire regdstE,alusrcE,pcsrcD,memtoregE,memtoregM,memtoregW,
			regwriteE,regwriteM,regwriteW;
	wire [4:0] alucontrolE;
	wire flushE,stallE,equalD;
	wire is_IMM;
	wire hi_writeM,lo_writeM,hi_writeW,lo_writeW;
	wire hi_to_regM;
	wire lo_to_regM;
	wire mfhiE,mfloE;
	wire [1:0]hi_mdrE,lo_mdrE;
	controller c(
		clk,rst,
		//decode stage
		instrD,
		pcsrcD,branchD,equalD,jumpD,
		is_IMM,
		//execute stage
		flushE,stallE,
		memtoregE,alusrcE,
		regdstE,regwriteE,	
		alucontrolE,
		mfhiE,mfloE,
		hi_mdrE,lo_mdrE,
		//mem stage
		memtoregM,memwriteM,
		regwriteM,hi_writeM,lo_writeM,hi_to_regM,lo_to_regM,
		//write back stage
		memtoregW,regwriteW,hi_writeW,lo_writeW
		);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		jumpD,
		equalD,
		instrD,
		is_IMM,
		//execute stage
		memtoregE,
		alusrcE,regdstE,
		regwriteE,
		alucontrolE,
		flushE,stallE,
		mfhiE,mfloE,
	    hi_mdrE,lo_mdrE,
		//mem stage
		memtoregM,
		regwriteM,
		aluoutM,writedataM,
		readdataM,
		hi_writeM,lo_writeM,
		hi_to_regM,
		lo_to_regM,
		//writeback stage
		memtoregW,
		regwriteW,
		hi_writeW,lo_writeW
	    );
	
endmodule