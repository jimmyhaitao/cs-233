.text

## int
## max_conts_bits_in_common(int a, int b) {
##     int bits_seen = 0;
##     int max_seen = 0;
##     int c = a & b;
##     for (int i = 0; i < INT_SIZE; i++) {
##         int bit = (c >> i) & 1;
##         if (bit) {
##             bits_seen++;
##         } else {
##             if (bits_seen > max_seen) {
##                 max_seen = bits_seen;
##             }
##             bits_seen = 0;
##         }
##     }
##     if (bits_seen > max_seen) {
##         max_seen = bits_seen;
##     }
##     return max_seen;
## }

.globl max_conts_bits_in_common
max_conts_bits_in_common:
	# Your code goes here :)
	li	$t1, 0	#int bits_seen = 0
	li	$t2, 0	#int max_seen = 0;
	and	$t3, $a0, $a1	#int c = a & b;
	li	$t4, 0	#i=0
	
max_conts_bits_in_common_loop:
	bge	$t4, 32, max_conts_bits_in_common_after_loop	#max_conts_bits_in_common:
	srl	$t5, $t3, $t4		#int bit = (c >> i)
	andi	$t5, $t5, 1	#bit=bit&1
	beq	$t5, 0, max_conts_bits_in_common_else
	add	$t1, $t1, 1	#bits_seen++;
	add	$t4, $t4, 1	#i++
	j	max_conts_bits_in_common_loop
max_conts_bits_in_common_else:
	ble	$t1, $t2, max_conts_bits_in_common_zero
	move	$t2, $t1	#max_seen = bits_seen;
	
max_conts_bits_in_common_zero:	
	li	$t1, 0	#bits_seen = 0;
	add	$t4, $t4, 1	#i++
	j	max_conts_bits_in_common_loop
	
max_conts_bits_in_common_after_loop:
	ble	$t1, $t2, max_conts_bits_in_common_return	#if (bits_seen > max_seen) 
	move	$t2, $t1	#max_seen = bits_seen;
	
max_conts_bits_in_common_return:
	move	$v0, $t2
	jr	$ra
	
