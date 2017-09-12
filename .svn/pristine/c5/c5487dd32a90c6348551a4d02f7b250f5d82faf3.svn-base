// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;
 
    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;
 
    always@(reset)
      if (reset == 1'b1)
        q <= reset_value;
 
    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;

endmodule // register

module decoder2 (out, in, enable);
    input     in;
    input     enable;
    output [1:0] out;
 
    and a0(out[0], enable, ~in);
    and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
    input [1:0]    in;
    input     enable;
    output [3:0]   out;
    wire [1:0]    w_enable;
 	
	decoder2 d41(w_enable,in[1],enable);
	decoder2 d42(out[1:0],in[0],w_enable[0]);
	decoder2 d43(out[3:2],in[0],w_enable[1]);
    // implement using decoder2's
    
endmodule // decoder4

module decoder8 (out, in, enable);
    input [2:0]    in;
    input     enable;
    output [7:0]   out;
    wire [3:0]    w_enable;
 	
	decoder4 d81(w_enable,in[2:1],enable);
	decoder2 d82(out[1:0],in[0],w_enable[0]);
	decoder2 d83(out[3:2],in[0],w_enable[1]);
	decoder2 d84(out[5:4],in[0],w_enable[2]);
	decoder2 d85(out[7:6],in[0],w_enable[3]);
    // implement using decoder2's and decoder4's
 
endmodule // decoder8

module decoder16 (out, in, enable);
    input [3:0]    in;
    input     enable;
    output [15:0]  out;
    wire [7:0]    w_enable;
 	decoder8 d161(w_enable,in[3:1],enable);
	decoder2 d162(out[1:0],in[0],w_enable[0]);
	decoder2 d163(out[3:2],in[0],w_enable[1]);
	decoder2 d164(out[5:4],in[0],w_enable[2]);
	decoder2 d165(out[7:6],in[0],w_enable[3]);
	decoder2 d166(out[9:8],in[0],w_enable[4]);
	decoder2 d167(out[11:10],in[0],w_enable[5]);
	decoder2 d168(out[13:12],in[0],w_enable[6]);
	decoder2 d169(out[15:14],in[0],w_enable[7]);
    // implement using decoder2's and decoder8's
 
endmodule // decoder16

module decoder32 (out, in, enable);
    input [4:0]    in;
    input     enable;
    output [31:0]  out;
    wire [15:0]    w_enable;
 	decoder16 d321(w_enable,in[4:1],enable);
	decoder2 d322(out[1:0],in[0],w_enable[0]);
	decoder2 d323(out[3:2],in[0],w_enable[1]);
	decoder2 d324(out[5:4],in[0],w_enable[2]);
	decoder2 d325(out[7:6],in[0],w_enable[3]);
	decoder2 d326(out[9:8],in[0],w_enable[4]);
	decoder2 d327(out[11:10],in[0],w_enable[5]);
	decoder2 d328(out[13:12],in[0],w_enable[6]);
	decoder2 d329(out[15:14],in[0],w_enable[7]);
	decoder2 d3210(out[17:16],in[0],w_enable[8]);
	decoder2 d3211(out[19:18],in[0],w_enable[9]);
	decoder2 d3212(out[21:20],in[0],w_enable[10]);
	decoder2 d3213(out[23:22],in[0],w_enable[11]);
	decoder2 d3214(out[25:24],in[0],w_enable[12]);
	decoder2 d3215(out[27:26],in[0],w_enable[13]);
	decoder2 d3216(out[29:28],in[0],w_enable[14]);
	decoder2 d3217(out[31:30],in[0],w_enable[15]);
	
    // implement using decoder2's and decoder16's
 
endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
             wr_regnum, wr_data, writeenable, 
             clock, reset);

    output [31:0]  rd1_data, rd2_data;
    input   [4:0]  rd1_regnum, rd2_regnum, wr_regnum;
    input  [31:0]  wr_data;
    input          writeenable, clock, reset;
 	wire [31:0] w_enable;
	wire [31:0] register [0:31];
    // build a register file!
    assign register[0]=0;
	decoder32 dr32(w_enable,wr_regnum,writeenable);
	
	register r1(register[1], wr_data, clock,w_enable[1],reset);
    register r2(register[2], wr_data, clock,w_enable[2],reset);
    register r3(register[3], wr_data, clock,w_enable[3],reset);
    register r4(register[4], wr_data, clock,w_enable[4],reset);
    register r5(register[5], wr_data, clock,w_enable[5],reset);
    register r6(register[6], wr_data, clock,w_enable[6],reset);
    register r7(register[7], wr_data, clock,w_enable[7],reset);
    register r8(register[8], wr_data, clock,w_enable[8],reset);
    register r9(register[9], wr_data, clock,w_enable[9],reset);
    register r10(register[10], wr_data, clock,w_enable[10],reset);
    register r11(register[11], wr_data, clock,w_enable[11],reset);
    register r12(register[12], wr_data, clock,w_enable[12],reset);
    register r13(register[13], wr_data, clock,w_enable[13],reset);
    register r14(register[14], wr_data, clock,w_enable[14],reset);
    register r15(register[15], wr_data, clock,w_enable[15],reset);
    register r16(register[16], wr_data, clock,w_enable[16],reset);
    register r17(register[17], wr_data, clock,w_enable[17],reset);
    register r18(register[18], wr_data, clock,w_enable[18],reset);
    register r19(register[19], wr_data, clock,w_enable[19],reset);
    register r20(register[20], wr_data, clock,w_enable[20],reset);
    register r21(register[21], wr_data, clock,w_enable[21],reset);
    register r22(register[22], wr_data, clock,w_enable[22],reset);
    register r23(register[23], wr_data, clock,w_enable[23],reset);
    register r24(register[24], wr_data, clock,w_enable[24],reset);
    register r25(register[25], wr_data, clock,w_enable[25],reset);
    register r26(register[26], wr_data, clock,w_enable[26],reset);
    register r27(register[27], wr_data, clock,w_enable[27],reset);
    register r28(register[28], wr_data, clock,w_enable[28],reset);
    register r29(register[29], wr_data, clock,w_enable[29],reset);
    register r30(register[30], wr_data, clock,w_enable[30],reset);
    register r31(register[31], wr_data, clock,w_enable[31],reset);
	
	mux32v mux1(rd1_data, register[0], register[1], register[2], register[3], register[4], register[5], register[6], register[7], register[8], register[9], register[10], register[11], register[12], register[13], register[14], register[15], register[16], register[17], register[18], register[19], register[20], register[21], register[22], register[23], register[24], register[25], register[26], register[27], register[28], register[29], register[30], register[31], rd1_regnum);
    mux32v mux2(rd2_data, register[0], register[1], register[2], register[3], register[4], register[5], register[6], register[7], register[8], register[9], register[10], register[11], register[12], register[13], register[14], register[15], register[16], register[17], register[18], register[19], register[20], register[21], register[22], register[23], register[24], register[25], register[26], register[27], register[28], register[29], register[30], register[31], rd2_regnum);
endmodule // mips_regfile

