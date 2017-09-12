module test;

   // these are inputs to "circuit under test"
   reg [1:0] first;
   reg [1:0] second;
  // wires for the outputs of "circuit under test"
   wire [1:0] out;
  // the circuit under test
   comparator c(out, first, second);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches
        
      // test all input combinations
      first = 0; second = 0; #10;
      first = 0; second = 1; #10;
      first = 0; second = 2; #10;
      first = 0; second = 3; #10;
      first = 1; second = 0; #10;
      first = 1; second = 1; #10;
      first = 1; second = 2; #10;
      first = 1; second = 3; #10;
      first = 2; second = 0; #10;
      first = 2; second = 1; #10;
      first = 2; second = 2; #10;
      first = 2; second = 3; #10;
      first = 3; second = 0; #10;
      first = 3; second = 1; #10;
      first = 3; second = 2; #10;
      first = 3; second = 3; #10;
      
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = first, second  outputs = out");
     $monitor("inputs = %b  %b  outputs = %b   time = %2t",
              first, second, out, $time);
   end
endmodule // test
