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
	input wire clk,rst,
	input wire[31:0] a,b,
	input wire[4:0] op,
	input wire [4:0] sa,
	input wire [63:0] hilo_in,
	
	output reg[31:0] y,
	output reg[63:0] hilo_out,
	
	output reg overflow
    );

	reg [31:0] temp_b;
    reg [31:0] temp_y;
    
    //乘法
    wire [31:0] mult_a,mult_b;
    wire [63:0] hilo_temp;
    wire [63:0] div_result;
    
    //除法
    reg signed_div;
    reg start_div;
    wire div_ready;

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
            `ALU_MFHI: y <= hilo_in[63:32];
            `ALU_MFLO: y <= hilo_in[31:0];
            `ALU_MTHI: y <= b;
            `ALU_MTLO: y <= a;
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

	//	//hilo_out的输出
	//    always @(*) begin
	//        case(op)
	//            `ALU_MTHI: hilo_out = {a[31:0],{hilo_in[31:0]}};
	//            `ALU_MTLO: hilo_out = {{hilo_in[63:32]},a[31:0]};
	//            `ALU_MULT: hilo_out = hilo_temp;
	//            `ALU_MULTU: hilo_out = a * b;
	//            `ALU_DIV: hilo_out = div_result;
	//            `ALU_DIVU: hilo_out = div_result;
	//        default: hilo_out = 64'b0;
	//        endcase
	
	
	//乘法
	
	
	//除法


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
