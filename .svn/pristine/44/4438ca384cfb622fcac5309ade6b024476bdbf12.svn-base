module luv_reader_test;

   reg reset = 1;
   reg [2:0] bits = 3'b0;
   reg clk = 0;
   always #5 clk = !clk;
   
   initial begin

      $dumpfile("luv.vcd");  
      $dumpvars(0, luv_reader_test);
      
      # 12
	reset = 0;
      # 20
	bits = 3'b000;     // I 
      # 10
	bits = 3'b111;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b111;//L
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b111;//U
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b111;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b110;//v
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b110;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b111;//U
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b111;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b111;//not i
	# 10
	bits = 3'b011;
	# 10
	bits = 3'b000;
	# 10
	bits = 3'b111;//not l
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b000;//not u
	# 10
	bits = 3'b111;
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b111;
	# 10
	bits = 3'b111;
	# 10
	bits = 3'b000;//not v
	# 10
	bits = 3'b110;
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b110;
	# 10
	bits = 3'b001;
	# 10
	bits = 3'b000;

      # 30
      $finish;              // end the simulation
   end                      
   
   wire I, L, U, V;
   luv_reader lr(I, L, U, V, bits, clk, reset);

   initial
     $monitor("At time %t, bits = %b I = %d L = %d U = %d V = %d reset = %x",
              $time, bits, I, L, U, V, reset);
endmodule // luv_reader_test
