`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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


//SoC top
module top(
	input clk,resetn
);

//cpu inst sram
wire        cpu_inst_en;
wire [3 :0] cpu_inst_wen;
wire [31:0] cpu_inst_addr;
wire [31:0] cpu_inst_wdata;
wire [31:0] cpu_inst_rdata;
//cpu data sram
wire        cpu_data_en;
wire [3 :0] cpu_data_wen;
wire [31:0] cpu_data_addr;
wire [31:0] cpu_data_wdata;
wire [31:0] cpu_data_rdata;

//cpu
mycpu_top cpu(
    .clk              (~clk      ),  //鐩稿綋浜庡inst_ram鍜宒ata_ram鏃堕挓鍙栧弽
    .resetn           (resetn    ),  //low active

    .inst_sram_en     (cpu_inst_en   ),
    .inst_sram_wen    (cpu_inst_wen  ),
    .inst_sram_addr   (cpu_inst_addr ),
    .inst_sram_wdata  (cpu_inst_wdata),
    .inst_sram_rdata  (cpu_inst_rdata),
    
    .data_sram_en     (cpu_data_en   ),
    .data_sram_wen    (cpu_data_wen  ),
    .data_sram_addr   (cpu_data_addr ),
    .data_sram_wdata  (cpu_data_wdata),
    .data_sram_rdata  (cpu_data_rdata)
);

//inst ram
inst_ram inst_ram
(
    .clka  (clk                ),   
    .ena   (cpu_inst_en        ),
    .wea   (cpu_inst_wen       ),
    .addra (cpu_inst_addr      ),
    .dina  (cpu_inst_wdata     ),
    .douta (cpu_inst_rdata     ) 
);

//data ram
data_ram data_ram
(
    .clka  (clk                 ),   
    .ena   (cpu_data_en         ),
    .wea   (cpu_data_wen        ),
    .addra (cpu_data_addr       ),
    .dina  (cpu_data_wdata      ),
    .douta (cpu_data_rdata      ) 
);
endmodule
