/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);

   // allocate an array for the output
   char *message_out = new char[length];

	// TODO: write your code here
	//sentence
	for(int i =0;i<length/8;i++){
		//letter
		for(int j=0;j<8;j++){
			char sum=0;
			//digit
			for(int k=0;k<8;k++){
				sum=sum+(((message_in[8*i+k]>>j)&0x1)<<k);
			}
		message_out[8*i+j]=sum;
		}
	}
	return message_out;
}
