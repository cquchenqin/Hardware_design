/* 
 * this header defines the control signal of ALU from decoder
 * 这一个文件头定义了从译码器到ALU的控制信号宏
 */
 
// logic instruction
`define SIG_ALU_AND     5'b00_000
`define SIG_ALU_OR      5'b00_001
`define SIG_ALU_XOR     5'b00_010
`define SIG_ALU_NOR     5'b00_011
`define SIG_ALU_LUI     5'b00_100
// shift instruction
`define SIG_ALU_SLL     5'b00_101
`define SIG_ALU_SRL     5'b00_110
`define SIG_ALU_SRA     5'b00_111
`define SIG_ALU_SLLV    5'b01_000
`define SIG_ALU_SRLV    5'b01_001
`define SIG_ALU_SRAV    5'b01_010

// move 
`define ALU_MFHI        5'b1_0001
`define ALU_MTHI        5'b1_0010
`define ALU_MFLO        5'b1_0011
`define ALU_MTLO        5'b1_0100



// fail
`define SIG_ALU_FAIL    5'b11_111



//`define CONTROLS_NOP  8'b00000000_000_0
//`define CONTROLS_ANDI  8'b00010100_000_0
//`define CONTROLS_ORI  8'b00010100_000_0
//`define CONTROLS_XORI  8'b00010100_000_0
//`define CONTROLS_LUI  8'b00010100_000_0
//`define CONTROLS_AND  8'b00001100_000_0
//`define CONTROLS_OR  8'b00001100_000_0
//`define CONTROLS_XOR  8'b00001100_000_0
//`define CONTROLS_NOR  8'b00001100_000_0

////memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,hilo_write,jal,jr,bal,memen
//`define CONTROLS_SLL  8'b00001100_000_0
//`define CONTROLS_SLLV  8'b00001100_000_0
//`define CONTROLS_SRL  8'b00001100_000_0
//`define CONTROLS_SRLV  8'b00001100_000_0
//`define CONTROLS_SRA  8'b00001100_000_0
//`define CONTROLS_SRAV  8'b00001100_000_0
                        
////memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,hilo_write,jal,jr,bal
//`define CONTROLS_MFHI 8'b00001100_000_0
//`define CONTROLS_MTHI 8'b00000001_000_0
//`define CONTROLS_MFLO 8'b00001100_000_0
//`define CONTROLS_MTLO 8'b00000001_000_0