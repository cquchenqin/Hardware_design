`timescale 1ns / 1ps
`include "define_alu_control.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
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


module alu(
	input wire[31:0] a,b,
	input wire[4:0] op,
	output reg[31:0] y,
	input wire [4:0] sa,
	output reg overflow,
	output wire zero
    );

	always @(*) begin
		case (op[4:0]) 
			// logic arithmetic
			`SIG_ALU_AND:	y = a & b;
			`SIG_ALU_OR :	y = a | b;
			`SIG_ALU_XOR:	y = a ^ b;
			`SIG_ALU_NOR:	y = ~(a | b);
			`SIG_ALU_LUI:	y = {b[15:0], 16'b0};
			// shift 
			`SIG_ALU_SLL:   y = b << sa;
			`SIG_ALU_SRL:   y = b >> sa;
			`SIG_ALU_SRA: 	y = $signed(b) >>> sa;
			`SIG_ALU_SLLV:  y = b << a;
			`SIG_ALU_SRLV: 	y = b >> a;
			`SIG_ALU_SRAV: 	y = $signed(b) >>> a;
			//move
			`ALU_MTHI: 		y = a;
			`ALU_MTLO: 		y = a;
			//arith
			`ALU_ADD: 		y = $signed(a)+$signed(b);
			`ALU_ADDU:		y = a + b;
			`ALU_SUB: 		y = $signed(a)-$signed(b);
			`ALU_SUBU:		y = a - b;
			`ALU_SLT:
			begin
				if (a[31]==0) begin
					if (b[31]==1) begin
						y = 0;
					end
					else if (a < b) begin
						y = 1;
					end
					else begin
						y = 0;
					end
				end
				else begin
					if (b[31]==0) begin
						y = 1;
					end
					else if (a < b) begin
						y = 1;
					end
					else begin
						y = 0;
					end
				end
			end
			`ALU_SLTU: 
			begin
				if (a<b)
					y = 1;
				else
					y = 0;
			end
			// fail
			`SIG_ALU_FAIL:	y <= 32'b0;
			default: y<= 32'b0;
		endcase
	end
	assign zero = (y == 32'b0);

	always @(*) begin
		case (op[4:0])
			default : overflow <= 1'b0;
		endcase	
	end
	// always @(*) begin
	// 	case (op[2:1])
	// 		2'b01:overflow <= a[31] & b[31] & ~s[31] |
	// 						~a[31] & ~b[31] & s[31];
	// 		2'b11:overflow <= ~a[31] & b[31] & s[31] |
	// 						a[31] & ~b[31] & ~s[31];
	// 		default : overflow <= 1'b0;
	// 	endcase	
	// end
endmodule
