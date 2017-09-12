// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

// make generator
// ./generator
#include <iostream>
using namespace std;

int
main() {
    int width = 32;
    cout<<"alui a0(out[0], cout[0], A[0], B[0], control[0], control)"<<endl;
    for (int i = 1 ; i < width ; i ++) {
         cout<<"alui a"<<i<<"(out["<<i<<"], cout["<<i<<"], A["<<i<<"], B["<<i<<"], cout["<<i-1<<"], control)"<<endl;
    }
}
