// Design a circuit that compares two two-bit unsigned
// inputs (first and second) using the following rules:

// - If the two inputs are equal, then the output is 00
// - If the first input is greater, then the output is 01
// - If the second input is greater, then the output is 10

module comparator(out, first, second);
   output [1:0] out;
   input  [1:0] first, second;
	wire f1,f2,s1,s2;
	assign f1=first[1];
	assign f2=first[0];
	assign s1=second[1];
	assign s2=second[0];
	assign out[0]=(f1&f2&(~s1|~s2))|(f1&~f2&~s1)|(~f1&f2&~s1&~s2);
	assign out[1]=(s1&s2&(~f1|~f2))|(s1&~s2&~f1)|(~s1&s2&~f1&~f2);
	
endmodule // comparator

