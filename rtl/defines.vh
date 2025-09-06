// ===== opcodes =====
`define OPC_RTYPE   7'b0110011
`define OPC_ITYPE   7'b0010011   // ADDI
`define OPC_LW      7'b0000011
`define OPC_SW      7'b0100011
`define OPC_BRANCH  7'b1100011
`define OPC_JAL     7'b1101111

// ===== funct3 for R-type =====
`define F3_ADD_SUB  3'b000
`define F3_SLL      3'b001
`define F3_SLT      3'b010
`define F3_SLTU     3'b011
`define F3_XOR      3'b100
`define F3_SRL_SRA  3'b101
`define F3_OR       3'b110
`define F3_AND      3'b111

// ===== funct7 subsets =====
`define F7_ADD      7'b0000000
`define F7_SUB      7'b0100000
`define F7_SRL      7'b0000000
`define F7_SRA      7'b0100000

// Immediate selector (which format?)
`define IMM_NONE 3'b000
`define IMM_I    3'b001  // ADDI, LW
`define IMM_S    3'b010  // SW
`define IMM_B    3'b011  // BEQ/BNE (branch)
`define IMM_J    3'b100  // JAL
// (Optionally IMM_U later for LUI/AUIPC)

