/* 
 * this header defines the macro of opcode and funct segment of instructions
 * 这一个文件头定义指令的opcode和funct字段的宏 
 */

// logic instruction (LOG)
// LOG - opcode
`define OP_RTYPE        6'b00_0000
`define	OP_AND	        6'b00_0000
`define	OP_OR	        6'b00_0000
`define OP_XOR	        6'b00_0000
`define OP_NOR	        6'b00_0000
`define OP_ANDI	        6'b00_1100
`define OP_XORI	        6'b00_1110
`define OP_LUI	        6'b00_1111
`define OP_ORI	        6'b00_1101
// LOG - funct
`define FUNC_AND	6'b10_0100
`define FUNC_OR		6'b10_0101
`define FUNC_XOR	6'b10_0110
`define FUNC_NOR	6'b10_0111

// shift instruction (SHIFT)
// SHIFT - opcode
`define OP_SLL      6'b00_0000
`define OP_SRL      6'b00_0000
`define OP_SRA      6'b00_0000
`define OP_SLLV     6'b00_0000
`define OP_SRLV     6'b00_0000
`define OP_SRAV     6'b00_0000

//算术
`define OP_ADDI     6'b00_1000
`define OP_ADDIU    6'b00_1001
`define OP_SLTI     6'b00_1010
`define OP_SLTIU    6'b00_1011   


// SHIFT - funct
`define FUNC_SLL    6'b00_0000  
`define FUNC_SRL    6'b00_0010  
`define FUNC_SRA    6'b00_0011
`define FUNC_SLLV   6'b00_0100 
`define FUNC_SRLV   6'b00_0110 
`define FUNC_SRAV   6'b00_0111 

//move - funct opcode=6'0000000
`define FUNC_MFHI  	6'b010000
`define FUNC_MTHI  	6'b010001
`define FUNC_MFLO  	6'b010010
`define FUNC_MTLO  	6'b010011

//算术运算
`define FUNC_SLT    6'b101010
`define FUNC_SLTU   6'b101011
`define FUNC_SLTI   6'b001010
`define FUNC_SLTIU  6'b001011   
`define FUNC_ADD    6'b100000
`define FUNC_ADDU   6'b100001
`define FUNC_SUB    6'b100010
`define FUNC_SUBU   6'b100011
`define FUNC_ADDI   6'b001000
`define FUNC_ADDIU  6'b001001

`define FUNC_MULT   6'b011000
`define FUNC_MULTU  6'b011001
`define FUNC_DIV    6'b011010
`define FUNC_DIVU   6'b011011  


// trap instruction (TRAP)
// TRAP - opcode
`define OP_BREAK    6'b00_0000
`define OP_SYSCALL  6'b00_0000
// TRAP - funct
`define FUNCT_BREAK    6'b00_1101
`define FUNCT_SYSCALL  6'b00_1100