`timescale 1ns / 1ps
`include "define_alu_control.vh"
`include "define_instr_dec.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:27:24
// Design Name: 
// Module Name: aludec
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


module aludec(
	input wire [31:0] instrD,
	output reg[4:0] alucontrol
    );
	wire [5:0] op,funct;
	assign op=instrD[31:26];
	assign funct=instrD[5:0];
	always @(*) begin
		if (op==`OP_RTYPE) begin
			case(funct)
				//logic arithmetic
				`FUNC_AND: alucontrol = `SIG_ALU_AND;
				`FUNC_OR:	alucontrol = `SIG_ALU_OR;
				`FUNC_XOR:	alucontrol = `SIG_ALU_XOR;
				`FUNC_NOR:	alucontrol = `SIG_ALU_NOR;
				//shift arithmetic
				`FUNC_SLL:	alucontrol = `SIG_ALU_SLL ;
				`FUNC_SRL :	alucontrol = `SIG_ALU_SRL ;
				`FUNC_SRA :	alucontrol = `SIG_ALU_SRA ;
				`FUNC_SLLV:	alucontrol = `SIG_ALU_SLLV;
				`FUNC_SRLV:	alucontrol = `SIG_ALU_SRLV;
				`FUNC_SRAV:	alucontrol = `SIG_ALU_SRAV;
				//hilo
				`FUNC_MFHI: alucontrol = `ALU_MFHI;
				`FUNC_MFLO: alucontrol = `ALU_MFLO;
				`FUNC_MTHI: alucontrol = `ALU_MTHI;
				`FUNC_MTLO: alucontrol = `ALU_MTLO;
				//arith
				`FUNC_ADD: 	alucontrol = `ALU_ADD;
				`FUNC_ADDU:	alucontrol = `ALU_ADDU;
				`FUNC_SUB:	alucontrol = `ALU_SUB;
				`FUNC_SUBU: alucontrol = `ALU_SUBU;
				`FUNC_SLT:  alucontrol = `ALU_SLT;
				`FUNC_SLTU: alucontrol = `ALU_SLTU;
				default: alucontrol = `SIG_ALU_FAIL;				
			endcase
		end
		else begin
			case(op)
				`OP_ANDI: alucontrol = `SIG_ALU_AND;
				`OP_XORI: alucontrol = `SIG_ALU_XOR;
				`OP_LUI:  alucontrol = `SIG_ALU_LUI;
				`OP_ORI:  alucontrol = `SIG_ALU_OR;
				`OP_ADDI: alucontrol = `ALU_ADD;
				`OP_ADDIU:alucontrol = `ALU_ADDU;
				`OP_SLTI: alucontrol = `ALU_SLT;
				`OP_SLTIU:alucontrol = `ALU_SLTU;
				default: alucontrol=`SIG_ALU_FAIL;
			endcase
		end
	end
endmodule
