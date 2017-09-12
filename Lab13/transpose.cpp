#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
	int tilesize=32;
    for (int i = 0; i < SIZE; i+=tilesize) {
        for (int j = 0; j < SIZE; j +=tilesize) {
        	for(int k=i;k<min(SIZE,i+tilesize);k++){
        		for(int l=j;l<min(SIZE,j+tilesize);l++){
        			dest[k][l] = src[l][k];
        		}
        	}
        }
    }
}
