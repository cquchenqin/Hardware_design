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
	input wire[4:0] op, //alucontrol
	input wire [4:0] sa, 
	
	output reg[31:0] y, //aluout
	output reg overflow
    );

    

    wire [32:0] au,bu,addu,subu;
	assign au={1'b0,a};
	assign bu={1'b0,b};
	assign addu=au+bu; //取低32位
	assign subu=au-bu;

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
            `ALU_MTHI: y = b;
            `ALU_MTLO: y = a;
            //算术指令
            `ALU_ADD:   y =a+b;
			`ALU_ADDU:  y =addu[31:0];
			`ALU_SUB:   y =a-b;
			`ALU_SUBU:  y =subu[31:0];
			`ALU_SLT:   y =(a[31]&!b[31])?1:((!a[31])&b[31])?0:(a<b);
			`ALU_SLTU:  y =(subu[32]==1)?1:0; 
			// fail
			`SIG_ALU_FAIL:	y = 32'b0;
			default: y = 32'b0;
		endcase
	end
	

	always @(*) begin
		case (op[4:0])
			default : overflow <= 1'b0;
		endcase	
	end

	
	
endmodule
