/*
 * CS 233 Spring 2017 Lab 7
 * clang++ lab7.cpp -o lab7
 */

#include <cassert>
#include <iostream>
#include <stdio.h>
#define INT_SIZE 32

// This is part 1.

/*
 * Function: detect_parity
 * --------------------
 * Determines if an integer's number of 1 bits is even
 * 
 *  number: integer number to check
 *  returns: 1 if bits are even, 0 if odd
 */
int
detect_parity(int number) {
    int bits_counted = 0;
    int return_value = 1;
    for (int i = 0; i < INT_SIZE; i++) {
        int bit = (number >> i) & 1;
        // zero is false, anything else is true
        if (bit) { 
            bits_counted++;
        }
    }
    if (bits_counted % 2 != 0) {
        return_value = 0;
    }
    return return_value;
}

/*
 * Function: max_conts_bits_in_common
 * --------------------
 * Determines how many continuous 1s two integers have
 *    in common
 * 
 *  a: the first integer
 *  b: the second integer
 *  returns: the number of continuous 1s a and b have in common
 */
int
max_conts_bits_in_common(int a, int b) {
    int bits_seen = 0;
    int max_seen = 0;
    int c = a & b;
    for (int i = 0; i < INT_SIZE; i++) {
        int bit = (c >> i) & 1;
        if (bit) {
            bits_seen++;
        } else {
            if (bits_seen > max_seen) {
                max_seen = bits_seen;
            }
            bits_seen = 0;
        }
    }
    if (bits_seen > max_seen) {
        max_seen = bits_seen;
    }
    return max_seen;
}

/*
 * Function: twisted_sum_array
 * --------------------
 * Sum all values of a 1D array together with a twist: the 
 *    sum is first divided by 2 if the mirrored value of i 
 *    in v is odd (the twist is to prevent being able to sum 
 *    up the array in the calculate_identity while loop)
 * 
 *  v: a 1D array of values
 *  length: the length of v
 *  returns: the twisted sum of the array
 */
int
twisted_sum_array(int *v, int length) {
    int sum = 0;
    for (int i = 0; i < length; i++) {
        if (v[length - 1 - i] & 1) {
            sum >>= 1;
        }
        sum += v[i];
    }
    return sum;
}

// This is part 2.

/*
 * Function: accumulate
 * --------------------
 * Accumulates two values based on rules if they have two 
 *    or more bits in common, OR them together else if value 
 *    has an odd parity, add it to total else multiply them 
 *    together
 *
 *  total: the integer being accumulated into
 *  value: the new value that needs to be incorporated into total
 *  returns: total after value has been merged in some way
 */
int
accumulate(int total, int value) {
    if (max_conts_bits_in_common(total, value) >= 2) {
        total = total | value;
    } else if (detect_parity(value) == 0) {
        total = total + value;
    } else {
        total = total * value;
    }
    return total;
}

/*
 * Function: calculate_identity
 * --------------------
 * Travels around a square array in a spiral starting at the top
 *    left and going clockwise, accumulating the values at each
 *    index until reaching the center
 *
 *  v: a size x size 1D array of values
 *  size: the side length of v
 *  returns: the secret identity hidden in v
 */
int turns[4] = {1, 0, -1, 0}; // Declared as a global
int
calculate_identity(int *v, int size) {
    int dist = size;
    int total = 0;
    int idx = -1;
    turns[1] = size;
    turns[3] = -size;
    while (dist > 0) {
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < dist; j++) {
                idx = idx + turns[i];
                total = accumulate(total, v[idx]);
                v[idx] = total;
            }
            if (i % 2 == 0) {
                dist--;
            }
        }
    }
    return twisted_sum_array(v, size * size);
}

// Unit tests.
// You can add more test cases here.
void
test_detect_parity() {
    // 0 = 0b0
    printf("detect_parity(0) is: %d\n", detect_parity(0));
    // 233 = 0b11101001 has 5 1s
    printf("detect_parity(233) is: %d\n", detect_parity(233));
}

void
test_max_conts_bits_in_common() {
    // 10 = 0b1010 and 5 = 0b101 have 0 continuous 1 in common
    printf("max_conts_bits_in_common(10, 5) is: %d\n",
           max_conts_bits_in_common(10, 5));
    // 237 = 0b11101101 and 239 = 0b11101111 have 3 continuous 1s in common
    printf("max_conts_bits_in_common(237, 239) is: %d\n",
           max_conts_bits_in_common(237, 239));
}

void
test_twisted_sum_array() {
    int even_array[] = {2, 4, 6, 8};
    printf("twisted_sum_array(even_array, 4) is: %d\n",
           twisted_sum_array(even_array, 4));
    int odd_array[] = {1, 3, 5, 7};
    printf("twisted_sum_array(odd_array, 4) is: %d\n",
           twisted_sum_array(odd_array, 4));
}

void
test_accumulate() {
    // 13 = 0b1101 15 = 0b1111 13 | 15 = 15
    printf("accumulate(13, 15) is: %d\n", accumulate(13, 15));
    // 42 = 0b101010 21 = 0b10101 42 + 21 = 63
    printf("accumulate(42, 21) is: %d\n", accumulate(42, 21));
    // 10 = 0b1010 15 = 0b1111 10 * 15 = 150
    printf("accumulate(10, 15) is: %d\n", accumulate(10, 15));
}

void
test_calculate_identity() {
    int two_by_two_mat[] = {1, 2, 3, 4};
    printf("calculate_identity(two_by_two_mat, 2) is: %d\n",
           calculate_identity(two_by_two_mat, 2));

    int five_by_five_mat[] = {0, 1, 2,  3, 7, 41, 5,   63, 7, 2,  2,  8, 2,
                              4, 1, 42, 5, 6, 1,  450, 8,  9, 10, 11, 25};
    printf("calculate_identity(five_by_five_mat, 5) is: %d\n",
           calculate_identity(five_by_five_mat, 5));
}

int
main(int argc, char **argv) {
    // test cases for part 1
    test_detect_parity();
    test_max_conts_bits_in_common();
    test_twisted_sum_array();
    // test cases for part 2
    test_accumulate();
    test_calculate_identity();
    return 0;
}
