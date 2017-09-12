// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
   output q;
   reg    q;
   input  d;
   input  clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= 0;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // dffe


module luv_reader(I, L, U, V, bits, clk, reset);
   output 	I, L, U, V;
   input [2:0] 	bits;
   input 	reset, clk;
	//I
   wire        	in000, in111,
				sGarbage, sGarbage_next,
				sBlank, sBlank_next,
				sI, sI_next,
				sI_end, sI_end_next;
	//L
	wire		in001,
				sGarbage2, sGarbage2_next,
				sBlank2, sBlank2_next,
				sL1, sL1_next,
				sL2, sL2_next,
				sL_end, sL_end_next;
	//U
	wire		sGarbage3, sGarbage3_next,
				sBlank3, sBlank3_next,
				sU1, sU1_next,
				sU2, sU2_next,
				sU3, sU3_next,
				sU_end, sU_end_next;
	//V
	wire		in110,
				sGarbage4, sGarbage4_next,
				sBlank4, sBlank4_next,
				sV1, sV1_next,
				sV2, sV2_next,
				sV3, sV3_next,
				sV_end, sV_end_next;
//I
	assign in000=(bits==3'b000);
    assign in111=(bits==3'b111);
		
    assign sGarbage_next = reset|((sBlank|sI_end)&~(in000|in111))|((sI|sGarbage)&~in000);
	assign sBlank_next = (sBlank | sI_end | sGarbage) & in000 &(~reset);
    assign sI_next = (sBlank | sI_end) & in111 &(~reset);
    assign sI_end_next = sI & in000 &(~reset);
	
	
    dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
    dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    dffe fsI(sI, sI_next, clk, 1'b1, 1'b0);
    dffe fsI_end(sI_end, sI_end_next, clk, 1'b1, 1'b0);
	
	assign I=sI_end;
//L
	assign in001=(bits==3'b001);

	assign sGarbage2_next=reset|(sGarbage2&~in000)|((sL_end|sBlank2)&~(in000|in111))|(sL1&~(in001|in000))|(sL2&~in000);
	assign sBlank2_next=in000&(sL1|sBlank2|sL_end|sGarbage2)&~reset;
	assign sL1_next=in111&(sBlank2|sL_end)&~reset;
	assign sL2_next=in001&sL1&~reset;
	assign sL_end_next=sL2 & in000&~reset; 
	
	dffe fsGarbage2(sGarbage2, sGarbage2_next, clk, 1'b1, 1'b0);
    dffe fsBlank2(sBlank2, sBlank2_next, clk, 1'b1, 1'b0);
    dffe fsL1(sL1, sL1_next, clk, 1'b1, 1'b0);
	dffe fsL2(sL2, sL2_next, clk, 1'b1, 1'b0);
    dffe fsL_end(sL_end, sL_end_next, clk, 1'b1, 1'b0);
	assign L=sL_end;
//U
	assign sGarbage3_next=reset|(sGarbage3&~in000)|(sBlank3&~(in000|in111))|(sU1&~(in000|in001))|(sU2&~(in000|in111))|(sU3&~(in000))|(sU_end&~(in000|in111));
	assign sBlank3_next=in000&(sGarbage3|sBlank3|sU1|sU2|sU_end)&~reset;
	assign sU1_next=in111&(sBlank3|sU_end) & ~reset;
	assign sU2_next=sU1 & in001 &~reset;
	assign sU3_next=sU2 & in111 & ~reset;
	assign sU_end_next=sU3& in000 &~reset;
	
	dffe fsGarbage3(sGarbage3, sGarbage3_next, clk, 1'b1, 1'b0);
    dffe fsBlank3(sBlank3, sBlank3_next, clk, 1'b1, 1'b0);
    dffe fsU1(sU1, sU1_next, clk, 1'b1, 1'b0);
	dffe fsU2(sU2, sU2_next, clk, 1'b1, 1'b0);
	dffe fsU3(sU3, sU3_next, clk, 1'b1, 1'b0);
    dffe fsU_end(sU_end, sU_end_next, clk, 1'b1, 1'b0);
	assign U=sU_end;
	
//V
	assign in110=(bits==3'b110);
	assign sGarbage4_next=reset|(sGarbage4&~in000)|(sBlank4&~(in000|in110))|(sV1&~(in000|in001))|(sV2&~(in000|in110))|(sV3&~in000)|(sV_end&~(in000|in110));
	assign sBlank4_next=in000& (sGarbage4|sBlank4|sV1|sV2|sV_end) &~reset;
	assign sV1_next=in110 & (sBlank4|sV_end) & ~reset;
	assign sV2_next= sV1 & in001 &~reset;
	assign sV3_next=sV2 & in110 & ~reset;
	assign sV_end_next=sV3 & in000 &~reset;
	
	dffe fsGarbage4(sGarbage4, sGarbage4_next, clk, 1'b1, 1'b0);
    dffe fsBlank4(sBlank4, sBlank4_next, clk, 1'b1, 1'b0);
    dffe fsV1(sV1, sV1_next, clk, 1'b1, 1'b0);
	dffe fsV2(sV2, sV2_next, clk, 1'b1, 1'b0);
	dffe fsV3(sV3, sV3_next, clk, 1'b1, 1'b0);
    dffe fsV_end(sV_end, sV_end_next, clk, 1'b1, 1'b0);
	assign V=sV_end;
	
	
	
endmodule // luv_reader
