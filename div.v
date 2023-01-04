`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/04 14:13:45
// Design Name: 
// Module Name: div
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

`include "define_alu_control.vh"

module div(
    input wire clk,rst,
    input wire signed_div_i, //1->有符号除法
    input wire[31:0] opdata1_i, //被除数
    input wire[31:0] opdata2_i, //除数
    input wire start_i, //1->开始除法运算
    input wire annul_i, //1->取消除法运算
    
    output reg[63:0] result_o,  //除法结果
    output reg ready_o //1->除法运算结束
    );
    
    //采用试商法
    
    //div模块主要是一个状态机
    //divfree 除法模块空闲 
    //divbyzero 除数为0
    //divon 除法运算中
    //divend 除法运算结束
    
    
    wire[32:0] div_temp;
	reg[5:0] cnt;
	reg[64:0] dividend;//dividend  高32位保存每次迭代的被除数  低32位保存中间结果
	reg[1:0] state;
	reg[31:0] divisor;	 
	reg[31:0] temp_op1;
	reg[31:0] temp_op2;
	
	assign div_temp = {1'b0,dividend[63:32]} - {1'b0,divisor};
    
    
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			state <= `DivFree;
			ready_o <= `DivResultNotReady;
			result_o <= {`ZeroWord,`ZeroWord};
		end else begin
		  case (state)
		  	`DivFree:begin               //divfree状态
		  		if(start_i == `DivStart && annul_i == 1'b0) begin
		  			if(opdata2_i == `ZeroWord) begin   //除数为0
		  				state <= `DivByZero;  
		  			end else begin                    //不为0
		  				state <= `DivOn;
		  				cnt <= 6'b000000;
		  				if(signed_div_i == 1'b1 && opdata1_i[31] == 1'b1 ) begin
		  					temp_op1 = ~opdata1_i + 1;  //被除数取补码
		  				end else begin
		  					temp_op1 = opdata1_i;
		  				end
		  				if(signed_div_i == 1'b1 && opdata2_i[31] == 1'b1 ) begin
		  					temp_op2 = ~opdata2_i + 1;   //除数取补码
		  				end else begin
		  					temp_op2 = opdata2_i;
		  				end
		  				dividend <= {`ZeroWord,`ZeroWord};
              dividend[32:1] <= temp_op1;
              divisor <= temp_op2;
             end
          end else begin  //未开始除法运算 start_i 
						ready_o <= `DivResultNotReady; 
						result_o <= {`ZeroWord,`ZeroWord};
				  end          	
		  	end
		  	`DivByZero:	begin               //如果state进入divbyzero状态，则除法运算结束，为0
         	dividend <= {`ZeroWord,`ZeroWord};
            state <= `DivEnd;		 		
		  	end
		  	`DivOn:	begin               //divon
		  		if(annul_i == 1'b0) begin
		  			if(cnt != 6'b100000) begin   //cnt不为32 则运算继续
               if(div_temp[32] == 1'b1) begin
                  dividend <= {dividend[63:0] , 1'b0};
               end else begin
                  dividend <= {div_temp[31:0] , dividend[31:0] , 1'b1};
               end
               cnt <= cnt + 1;
             end else begin  
               if((signed_div_i == 1'b1) && ((opdata1_i[31] ^ opdata2_i[31]) == 1'b1)) begin
                  dividend[31:0] <= (~dividend[31:0] + 1);
               end
               if((signed_div_i == 1'b1) && ((opdata1_i[31] ^ dividend[64]) == 1'b1)) begin              
                  dividend[64:33] <= (~dividend[64:33] + 1);
               end
               state <= `DivEnd;  //试商法结束，进入divend状态
               cnt <= 6'b000000;            	
             end
		  		end else begin  //annal为1 强制停止除法运算
		  			state <= `DivFree;
		  		end	
		  	end
		  	`DivEnd:			begin               //DivEnd
        	result_o <= {dividend[64:33], dividend[31:0]};  
            ready_o <= `DivResultReady;
            if(start_i == `DivStop) begin
          	state <= `DivFree;
						ready_o <= `DivResultNotReady;
						result_o <= {`ZeroWord,`ZeroWord};       	
          end		  	
		  	end
		  endcase
		end
	end
    
    
endmodule
