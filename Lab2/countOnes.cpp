/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned odd=0x55555555&input;
	unsigned even=0xAAAAAAAA&input;
	input=(even>>1)+odd;
	
	odd=0x33333333&input;
	even=0xCCCCCCCC&input;
	input=(even>>2)+odd;
	
	odd=0x0F0F0F0F&input;
	even=0xF0F0F0F0&input;
	input=(even>>4)+odd;
	
	odd=0x00FF00FF&input;
	even=0xFF00FF00&input;
	input=(even>>8)+odd;
	
	odd=0x0000FFFF&input;
 	even=0xFFFF0000&input;
	input=(even>>16)+odd;
	return input;
}
