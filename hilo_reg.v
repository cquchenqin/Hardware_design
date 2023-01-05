`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/04 02:11:20
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(
        input wire clk,rst,
        input wire we,      //HI,LO寄存器写信号
        input wire[31:0] hi_i,
        input wire [31:0] lo_i,
        output reg [31:0] hi_o,
        output reg [31:0] lo_o
    );
    always @(posedge clk) begin
        if(rst) begin
            hi_o <= 0;
            lo_o <= 0;
        end 
        else if (we) begin
            hi_o <= hi_i;
            lo_o <= lo_i;
        end
    end

endmodule
