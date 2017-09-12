module blackbox_test;

    reg s_in, i_in, w_in;                           // these are inputs to "circuit under test"
                                              // use "reg" not "wire" so can assign a value
    wire l_out;                        // wires for the outputs of "circuit under test"

    blackbox b1 (l_out, s_in, i_in, w_in);  // the circuit under test
    
    initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
        $dumpfile("b.vcd");                  // name of dump file to create
        $dumpvars(0,blackbox_test);                 // record all signals of module "sc_test" and sub-modules
                                              // remember to change "sc_test" to the correct
                                              // module name when writing your own test benches
        
        // test all four input combinations
        // remember that 2 inputs means 2^2 = 4 combinations
        // 3 inputs would mean 2^3 = 8 combinations to test, and so on
        // this is very similar to the input columns of a truth table
        s_in = 0; i_in = 0; w_in = 0; # 10;             // set initial values and wait 10 time units
        s_in = 0; i_in = 0; w_in = 1; # 10;             // change inputs and then wait 10 time units
        s_in = 0; i_in = 1; w_in = 0; # 10;             // as above
        s_in = 0; i_in = 1; w_in = 1; # 10;
        s_in = 1; i_in = 0; w_in = 0; # 10;
        s_in = 1; i_in = 0; w_in = 1; # 10;
        s_in = 1; i_in = 1; w_in = 0; # 10;
        s_in = 1; i_in = 1; w_in = 1; # 10;
 
        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, s_in = %d i_in = %d w_in = %d l_out = %d",
                 $time, s_in, i_in, w_in, l_out);
endmodule // blackbox_test
