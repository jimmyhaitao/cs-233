module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
    
    wire [31:2]  PCplus4_EX;
    wire [31:0]  inst_EX, alu_out_data_MW, rd1_data_, rd2_data_;
    wire [4:0]   rs_EX = inst_EX[25:21];
    wire [4:0]   rt_EX = inst_EX[20:16];
    wire [4:0]   rd_EX = inst_EX[15:11];
    wire [5:0]   opcode_EX  = inst_EX[31:26];
    wire [5:0]   funct_EX = inst_EX[5:0];
    wire [31:0]  imm_EX = {{16{inst_EX[15]}}, inst_EX[15:0]};
    wire [31:0]  rd2_data_MW;
    wire MemToReg_MW, RegWrite_MW, MemRead_MW, MemWrite_MW;
    wire [4:0]   wr_regnum_MW;
    // DO NOT comment out or rename this module
    // or the test bench will break
   
    
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */~stall, reset);
    
 
    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PCplus4_EX, imm_EX[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode_EX, funct_EX);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs_EX, rt_EX, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    wire flush =  PCSrc;

    mux2v #(32) imm_mux(B_data, rd2_data_, imm_EX, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data_, B_data);

    register #(30,30'h100000) PCsrc(PCplus4_EX[31:2], PC_plus4[31:2], clk, ~stall, reset | flush);
    register #(32) inst_(inst_EX, inst, clk, ~stall, reset | flush);
    
    register #(32) alu_(alu_out_data_MW, alu_out_data, clk, 1'b1, reset);
    register #(32) rd2_d(rd2_data_MW, rd2_data_, clk, 1'b1, reset);
    
    register #(1)  mtr(MemToReg_MW, MemToReg, clk, 1'b1, reset|stall);
    register #(1)  rw(RegWrite_MW, RegWrite, clk, 1'b1, reset|stall);

    register #(1)  MemRead_(MemRead_MW, MemRead, clk, 1'b1, reset|stall);
    register #(1)  MemwR_(MemWrite_MW, MemWrite, clk, 1'b1, reset|stall);

    register #(5)  wr(wr_regnum_MW, wr_regnum, clk, 1'b1, reset);
 
    wire forwardA = (wr_regnum_MW == rs_EX) & RegWrite_MW & (wr_regnum_MW!= 0);
    wire forwardB = (wr_regnum_MW == rt_EX) & RegWrite_MW & (wr_regnum_MW!= 0);
    wire stall = (MemRead_MW == 1) & ((wr_regnum_MW == rs_EX) | (wr_regnum_MW == rt_EX)) & (wr_regnum_MW!= 0);


    mux2v #(32)  forwardA_(rd1_data_, rd1_data, alu_out_data_MW, forwardA);
    mux2v #(32)  forwardB_(rd2_data_, rd2_data, alu_out_data_MW, forwardB);
    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt_EX, rd_EX, RegDst);
endmodule // pipelined_machine
