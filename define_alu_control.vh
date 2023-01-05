/* 
 * this header defines the control signal of ALU from decoder
 * 这一个文件头定义了从译码器到ALU的控制信号宏
 */
`define RstEnable 		1'b1
`define RstDisable		1'b0
`define ZeroWord		32'h00000000


//div
`define DivFree 2'b00
`define DivByZero 2'b01
`define DivOn 2'b10
`define DivEnd 2'b11
`define DivResultReady 1'b1
`define DivResultNotReady 1'b0
`define DivStart 1'b1
`define DivStop 1'b0


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

// 算术运算
`define ALU_MFHI        5'b01_011
`define ALU_MFLO        5'b01_100
`define ALU_MTHI        5'b01_101
`define ALU_MTLO        5'b01_110

`define ALU_ADD         5'b10_000
`define ALU_ADDU        5'b10_001
`define ALU_SUB         5'b10_010
`define ALU_SUBU        5'b10_011
`define ALU_SLT         5'b10_100
`define ALU_SLTU        5'b10_101

`define ALU_MULT        5'b11_000
`define ALU_MULTU       5'b11_001
`define ALU_DIV         5'b11_010
`define ALU_DIVU        5'b11_011

// fail
`define SIG_ALU_FAIL    5'b11_111



