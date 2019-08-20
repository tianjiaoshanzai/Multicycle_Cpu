// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10   

// B control signal
`define EXT 1'b1
`define B	1'b0

// EXT control signal
`define EXT_ZERO    2'b00
`define EXT_SIGNED  2'b01
`define EXT_HIGHPOS 2'b10

// ALU control signal
`define ALUOp_ADDU  4'b0000
`define ALUOp_SUBU  4'b0001
`define ALUOp_AND    4'b0010
`define ALUOp_OR    4'b0011
`define ALUOp_XOR    4'b0100
`define ALUOp_NOR    4'b0101

// GPR control signal
`define RFSel_RD   2'b00
`define RFSel_RT   2'b01
`define RFSel_31   2'b10

`define GPRSel_RD   2'b00
`define GPRSel_RT   2'b01
`define GPRSel_31   2'b10

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC  2'b10