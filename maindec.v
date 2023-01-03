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
	output wire is_IMM
    );
	wire [5:0] op;
	reg[6:0] controls;
	assign op = instr[31:26];
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump} = controls;
	always @(*) begin
		case (op)
			`OP_RTYPE:controls <= 7'b1100000;
			`OP_ANDI: controls <= 7'b1010000;
			`OP_XORI: controls <= 7'b1010000;
			`OP_LUI:  controls <= 7'b1010000;
			`OP_ORI:  controls <= 7'b1010000;
			6'b100011:controls <= 7'b1010010;//LW
			6'b101011:controls <= 7'b0010100;//SW
			6'b000100:controls <= 7'b0001000;//BEQ
			6'b001000:controls <= 7'b1010000;//ADDI
			6'b000010:controls <= 7'b0000001;//J
			default:  controls <= 7'b0000000;//illegal op
		endcase
	end
	assign is_IMM = (op[5:2] == 4'b0011) ? 1'b1 : 1'b0;
endmodule
