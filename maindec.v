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


module maindec(
	input wire[31:0] instr,
	output wire memtoreg,memwrite,
	output wire branch,alusrc,
	output wire regdst,regwrite,
	output wire jump,
	output wire is_IMM,
	output wire hilo_write,
	output wire hi_to_reg,
	output wire lo_to_reg
    );
	wire [5:0] op;
	wire [5:0] funct;
	reg[9:0] controls;
	assign op = instr[31:26];
	assign funct = instr[5:0];
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,hilo_write,hi_to_reg,lo_to_reg} = controls;
	always @(*) begin
		case (op)
			`OP_RTYPE:case(funct)  
			 // other part of logic inst
                   `FUNC_AND:controls <= 10'b1100000000;
                   `FUNC_OR:controls  <= 10'b1100000000;
                   `FUNC_XOR:controls <= 10'b1100000000;
                   `FUNC_NOR:controls <= 10'b1100000000;
             // shift inst0
                   `FUNC_SLL:controls <= 10'b1100000000;
                   `FUNC_SLLV:controls<= 10'b1100000000;
                   `FUNC_SRL:controls <= 10'b1100000000;
                   `FUNC_SRLV:controls<= 10'b1100000000;
                   `FUNC_SRA:controls <= 10'b1100000000;
                   `FUNC_SRAV:controls<= 10'b1100000000;
             //move inst0
                   `FUNC_MFHI:controls<= 10'b1100000010;
                   `FUNC_MTHI:controls<= 10'b0000000100;//MTXX类型   将通用寄存器中的值写入hilo寄存器中 hilo_write=1
                   `FUNC_MFLO:controls<= 10'b1100000001;
                   `FUNC_MTLO:controls<= 10'b0000000100;
                   default: controls  <= 10'b0000000000;
                   endcase
			`OP_ANDI: controls <= 10'b1010000000;
			`OP_XORI: controls <= 10'b1010000000;
			`OP_LUI:  controls <= 10'b1010000000;
			`OP_ORI:  controls <= 10'b1010000000;
			6'b100011:controls <= 10'b1010010000;//LW
			6'b101011:controls <= 10'b0010100000;//SW
			6'b000100:controls <= 10'b0001000000;//BEQ
			6'b001000:controls <= 10'b1010000000;//ADDI
			6'b000010:controls <= 10'b0000001000;//J
			default:  controls <= 10'b0000000000;//illegal op
		endcase
	end
	assign is_IMM = (op[5:2] == 4'b0011) ? 1'b1 : 1'b0;
endmodule
