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
	output wire hilo_write //是否写入hi_lo寄存器
    );
	wire [5:0] op;
	wire [5:0] funct;
	reg[6:0] controls;
	assign op = instr[31:26];
	assign funct = instr[5:0]; 

	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,hilo_write} = controls;
	always @(*) begin
		case (op)
			`OP_RTYPE:case(funct)  
			 // other part of logic inst
                   `FUNC_AND:controls <= 8'b11000000;
                   `FUNC_OR:controls <= 8'b11000000;
                   `FUNC_XOR:controls <= 8'b11000000;
                   `FUNC_NOR:controls <= 8'b11000000;
             // shift inst
                   `FUNC_SLL:controls <= 8'b11000000;
                   `FUNC_SLLV:controls <= 8'b11000000;
                   `FUNC_SRL:controls <= 8'b11000000;
                   `FUNC_SRLV:controls <= 8'b11000000;
                   `FUNC_SRA:controls <= 8'b11000000;
                   `FUNC_SRAV:controls <= 8'b11000000;
             //move inst
                   `FUNC_MFHI:controls <= 8'b11000000;
                   `FUNC_MTHI:controls <= 8'b11000001;//MTXX类型   将通用寄存器中的值写入hilo寄存器中 hilo_write=1
                   `FUNC_MFLO:controls <= 8'b11000000;
                   `FUNC_MTLO:controls <= 8'b11000001;
                   default:begin
                        controls <= 8'b00000000;
                   end
                   endcase
			`OP_ANDI: controls <= 8'b10100000;
			`OP_XORI: controls <= 8'b10100000;
			`OP_LUI:  controls <= 8'b10100000;
			`OP_ORI:  controls <= 8'b10100000;
			6'b100011:controls <= 8'b10100100;//LW
			6'b101011:controls <= 8'b00101000;//SW
			6'b000100:controls <= 8'b00010000;//BEQ
			6'b001000:controls <= 8'b10100000;//ADDI
			6'b000010:controls <= 8'b00000010;//J
			default:  controls <= 8'b00000000;//illegal op
		endcase
	end
	assign is_IMM = (op[5:2] == 4'b0011) ? 1'b1 : 1'b0;
endmodule
