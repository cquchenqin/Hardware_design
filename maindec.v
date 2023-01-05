`timescale 1ns / 1ps
`include "define_alu_control.vh"
`include "define_instr_dec.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
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
`include "define_instr_dec.vh"

module maindec(
	input wire[31:0] instr,
	output wire memtoreg,memwrite,
	output wire branch,alusrc,
	output wire regdst,regwrite,
	output wire jump,
	output wire is_IMM,
	output wire hi_write,lo_write, //是否写入hi_lo寄存器
	output wire mfhi,mflo, //mf指令
	output wire [1:0]hi_mdr,lo_mdr,
	output wire hi_to_reg,
	output wire lo_to_reg
    );

	wire [5:0] op;
	wire [5:0] funct;
	reg[12:0] controls;
	assign op = instr[31:26];
	assign funct = instr[5:0];

	wire mul, div;
	wire mthi, mtlo;
	
	assign mul = op == `OP_RTYPE & (funct == `FUNC_MULT | funct == `FUNC_MULTU);
	assign div = op == `OP_RTYPE & (funct == `FUNC_DIV | funct == `FUNC_DIVU);
	assign mthi = op == `OP_RTYPE & funct == `FUNC_MTHI;
	assign mtlo = op == `OP_RTYPE & funct == `FUNC_MTLO;
	
	
	assign hi_mdr = {mul, div, mthi} == 3'b100 ? 2'b01 :
               		{mul, div, mthi} == 3'b010 ? 2'b10 :
               		{mul, div, mthi} == 3'b001 ? 2'b11 :
               		2'b00;
	assign lo_mdr = {mul, div, mthi} == 3'b100 ? 2'b01 :
               		{mul, div, mthi} == 3'b010 ? 2'b10 :
               		{mul, div, mthi} == 3'b001 ? 2'b11 :
               		2'b00;

	assign hi_write = mul | div | mthi;
	assign lo_write = mul | div | mtlo;
 

	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,mfhi,mflo,hi_write,lo_write,hi_to_reg,lo_to_reg} = controls;
	//写寄存器使能，写通用目的寄存器，是否选择立即数，分支指令，存储数据使能，load写寄存器使能，跳转指令，MFHI,MFLO，hi写寄存器使能,lo写寄存器使能，选择写hi还是lo
	always @(*) begin
		case (op)
			`OP_RTYPE:case(funct)  
			 // other part of logic inst
                   `FUNC_AND:controls <= 13'b1100000_000000;
                   `FUNC_OR:controls  <= 13'b1100000_000000;
                   `FUNC_XOR:controls <= 13'b1100000_000000;
                   `FUNC_NOR:controls <= 13'b1100000_000000;
             // shift inst
                   `FUNC_SLL:controls <= 13'b1100000_000000;
                   `FUNC_SLLV:controls<= 13'b1100000_000000;
                   `FUNC_SRL:controls <= 13'b1100000_000000;
                   `FUNC_SRLV:controls<= 13'b1100000_000000;
                   `FUNC_SRA:controls <= 13'b1100000_000000;
                   `FUNC_SRAV:controls<= 13'b1100000_000000;
             //move inst
                   `FUNC_MFHI:controls<= 13'b1100000_100010;
                   `FUNC_MFLO:controls<= 13'b1100000_010001;
				   `FUNC_MTHI:controls<= 13'b0000000_001000;//MTXX类型   将通用寄存器中的值写入hilo寄存器中 hilo_write=1
                   `FUNC_MTLO:controls<= 13'b0000000_000100;
			 //mul_div
				   `FUNC_MULT:controls<= 13'b0100000_001100;
				   `FUNC_MULTU:controls<=13'b0100000_001100;
				   `FUNC_DIV: controls<= 13'b0100000_001100;
				   `FUNC_DIVU:controls<= 13'b0100000_001100; 

                   default:begin
                        controls <= 13'b1100000_000000;//R-TYPE
                   end
                   endcase
			`OP_ANDI: controls <= 13'b1010000_000000;
			`OP_XORI: controls <= 13'b1010000_000000;
			`OP_LUI:  controls <= 13'b1010000_000000;
			`OP_ORI:  controls <= 13'b1010000_000000;
			6'b100011:controls <= 13'b1010010_000000;//LW
			6'b101011:controls <= 13'b0010100_000000;//SW
			6'b000100:controls <= 13'b0001000_000000;//BEQ
			6'b001000:controls <= 13'b1010000_000000;//ADDI
			6'b000010:controls <= 13'b0000001_000000;//J
			
			//I 算术运算
			`OP_ADDI: controls <= 13'b1010000_000000;
			`OP_ADDIU:controls <= 13'b1010000_000000;
			`OP_SLTI: controls <= 13'b1010000_000000;
			`OP_SLTIU:controls <= 13'b1010000_000000;

			default:  controls <= 13'b0000000_000000;//illegal op
		endcase
	end
	assign is_IMM = (op[5:2] == 4'b0011) ? 1'b1 : 1'b0;
endmodule
