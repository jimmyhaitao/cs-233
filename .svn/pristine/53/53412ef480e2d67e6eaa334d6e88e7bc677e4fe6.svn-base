module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v
	
    // cycle through all combinations of A, B, C, D every 16 time units
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg Cin=0;
	always #4 Cin = !Cin;
    reg [2:0] control = 2;
     
    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        # 8 control = 3; // wait 16 time units (why 16?) and then set it to 1
        # 8 control = 4; // wait 16 time units and then set it to 2
        # 8 control = 5; // wait 16 time units and then set it to 3
		# 8 control = 6;
		# 8 control = 7;
        # 8 $finish; // wait 16 time units and then end the simulation
    end

    wire out,carryout;
    alu1 al1(out, carryout,A, B,Cin, control);

    // you really should be using gtkwave instead
    /*
    initial begin
        $display("A B C D s o");
        $monitor("%d %d %d %d %d %d (at time %t)", A, B, C, D, control, out, $time);
    end
    */
endmodule
