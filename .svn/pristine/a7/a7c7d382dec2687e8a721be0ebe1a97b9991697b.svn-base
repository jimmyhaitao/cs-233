`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           regnum, wr_data, next_pc, TimerInterrupt,
           MTC0, ERET, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input   [4:0] regnum;
    input  [31:0] wr_data;
    input  [29:0] next_pc;
    input         TimerInterrupt, MTC0, ERET, clock, reset;
	wire [31:0] user_status,mtcout;
	wire mtc012,mtc014;
	wire [29:0] EPCD;
	wire exceptreset;
	wire exception_level;
	wire EPCenable;
	wire [31:0] status_register,cause_register,q31;
    // your Verilog for coprocessor 0 goes here
	register #(32) UStatus (user_status,wr_data,clock,mtc012,reset);
	decoder32 mtc0decoder(mtcout,regnum,MTC0);
	assign mtc012=mtcout[12];
	assign mtc014=mtcout[14];
	mux2v #(30) mux1(EPCD,wr_data[31:2],next_pc,TakenInterrupt);
	assign exceptreset=(reset|ERET);
	dffe dffe1 (exception_level, 1, clock, TakenInterrupt, exceptreset);
	assign EPCenable=(TakenInterrupt|mtc014);
	register #(30) EPCregister(EPC,EPCD,clock,EPCenable,reset);
	assign status_register[31:16]=16'b0;
	assign status_register[15:8]=user_status[15:8];
	assign status_register[7:2]=6'b0;
	assign status_register[1]=exception_level;
	assign status_register[0]=user_status[0];
	assign cause_register[15]=TimerInterrupt;
	assign cause_register[31:16]=16'b0;
	assign cause_register[14:0]=15'b0;
	assign q31={EPC,2'b0};
	mux32v #(32) mux2(rd_data,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,status_register,cause_register,q31,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,regnum);
	assign TakenInterrupt=(status_register[15]&cause_register[15])&(~status_register[1]&status_register[0]);
endmodule
