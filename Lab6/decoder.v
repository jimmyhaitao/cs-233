// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;
	//old
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
	//new
	wire bne=opcode==`OP_BNE;
	wire beq=opcode==`OP_BEQ;
	wire j=opcode==`OP_J;
	wire jr=r&(funct==`OP0_JR);
	wire LUI=opcode==`OP_LUI;
	wire SLT=r&(funct==`OP0_SLT);
	wire lw=opcode==`OP_LW;
	wire lbu=opcode==`OP_LBU;
	wire sw=opcode==`OP_SW;
	wire sb=opcode==`OP_SB;
	wire ADDM=r&(funct==`OP0_ADDM);
	assign writeenable=(addi|andi|ori|xori|add|sub|myand|myor|mynor|myxor|LUI|SLT|lw|lbu|ADDM);
	assign except=~(addi|andi|ori|xori|add|sub|myand|myor|mynor|myxor|bne|beq|j|jr|LUI|SLT|lw|lbu|sw|sb|ADDM);
	assign rd_src=(addi|andi|ori|xori|LUI|lw|lbu);
	assign alu_src2=(addi|andi|ori|xori|lw|lbu|sw|sb);
	assign alu_op[0]=(sub|myor|myxor|ori|xori|beq|bne|SLT);
	assign alu_op[1]=(add|sub|mynor|myxor|addi|xori|beq|bne|SLT|lw|lbu|sw|sb|ADDM);
	assign alu_op[2]=(myand|myor|mynor|myxor|andi|ori|xori);
	assign control_type[0]=(jr|(zero&beq)|(~zero&bne));
	assign control_type[1]=(j|jr);
	assign mem_read=(lw|lbu|ADDM);
	assign word_we=sw;
	assign byte_we=sb;
	assign byte_load=lbu;
	assign lui=LUI;
	assign slt=SLT;
	assign addm=ADDM;
endmodule // mips_decode
