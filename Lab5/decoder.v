// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;
	
	wire r =opcode==`OP_OTHER0;
	wire addi=opcode==`OP_ADDI;
	wire andi=opcode==`OP_ANDI;
	wire ori=opcode==`OP_ORI;
	wire xori=opcode==`OP_XORI;
	wire add=r&(funct==`OP0_ADD);
	wire sub=r&(funct==`OP0_SUB);
	wire myand=r&(funct==`OP0_AND);
	wire myor=r&(funct==`OP0_OR);
	wire mynor=r&(funct==`OP0_NOR);
	wire myxor=r&(funct==`OP0_XOR);
	assign writeenable=(addi|andi|ori|xori|add|sub|myand|myor|mynor|myxor);
	assign except=~writeenable;
	assign rd_src=(addi|andi|ori|xori);
	assign alu_src2=(addi|andi|ori|xori);
	assign alu_op[0]=(sub|myor|myxor|ori|xori);
	assign alu_op[1]=(add|sub|mynor|myxor|addi|xori);
	assign alu_op[2]=(myand|myor|mynor|myxor|andi|ori|xori);
endmodule // mips_decode
