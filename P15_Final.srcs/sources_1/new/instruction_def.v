// OP
`define INSTR_RTYPE_OP      6'b000000
`define INSTR_LW_OP         6'b100011
`define INSTR_SW_OP         6'b101011
`define INSTR_ADDIU_OP        6'b001001  
`define INSTR_ANDI_OP        6'b001100  
`define INSTR_ORI_OP        6'b001101  
`define INSTR_XORI_OP        6'b001110

`define INSTR_BEQ_OP        6'b000100
`define INSTR_BNE_OP        6'b000101

`define INSTR_J_OP        6'b000010
`define INSTR_JAL_OP      6'b000011

// Funct
`define INSTR_ADDU_FUNCT    6'b100001
`define INSTR_SUBU_FUNCT    6'b100011
`define INSTR_AND_FUNCT    6'b1100100
`define INSTR_OR_FUNCT    6'b100101
`define INSTR_XOR_FUNCT    6'b100110
`define INSTR_NOR_FUNCT    6'b100111
