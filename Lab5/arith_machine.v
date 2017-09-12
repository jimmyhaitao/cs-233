// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module sign_extender(out,in);
	output [31:0] out;
	input [15:0] in;
	
	assign out[15:0]=in[15:0];
	assign out[31:16]={16{in[15]}};
endmodule

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
	wire [31:0] nextPC;
	wire [2:0] alu_op;
	wire [31:0] imm32;
	wire [31:0] A,B,rtData,out;
	wire [4:0] rdest;
	wire wr_enable, alu_src2,rd_src;
	wire overflow,zero,negative;
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC,nextPC,clock,1,reset);
	alu32 pcplus4(nextPC,,,,PC,32'h4,`ALU_ADD);
    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst,PC[31:2]);
    mips_decode mipsdecode1(alu_op,wr_enable,rd_src,alu_src2,except,inst[31:26],inst[5:0]);
	sign_extender se1(imm32,inst[15:0]);
    // DO NOT comment out or rename this module
    // or the test bench will break
    mux2v #(5) rd(rdest,inst[15:11],inst[20:16],rd_src);
    mux2v #(32) alusrc(B,rtData,imm32,alu_src2);
    alu32 alu(out,overflow,zero,negative,A,B,alu_op);
    regfile rf (A,rtData,inst[25:21],inst[20:16],rdest,out,wr_enable,clock,reset);

    /* add other modules */
  	
endmodule // arith_machine
