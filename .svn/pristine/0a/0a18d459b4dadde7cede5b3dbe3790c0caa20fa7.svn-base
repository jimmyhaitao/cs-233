.text

## int
## twisted_sum_array(int *v, int length) {
##     int sum = 0;
##     for (int i = 0; i < length; i++) {
##         if (v[length - 1 - i] & 1) {
##             sum >>= 1;
##         }
##         sum += v[i];
##     }
##     return sum;
## }

.globl twisted_sum_array
twisted_sum_array:
	# Your code goes here :)
	li	$v0, 0		#int sum = 0;
	li	$t2, 0		#int i = 0;
twisted_sum_array_loop:
	bge	$t2, $a1, twisted_sum_array_return	#go to after loop
	sub	$t3, $a1, 1	#length - 1
	sub	$t3, $t3, $t2	#length-1-i
	sll	$t3, $t3, 2	#4*(length-1-i) 
	add	$t4, $a0, $t3	#v+4*(length-1-i) 
	lw	$t6, 0($t4)	#v[length - 1 - i]
	andi	$t4, $t6, 1	#(v[length - 1 - i] & 1)	
	beq	$t4, 0, twisted_sum_array_plus	#branch
	sra	$v0, $v0, 1	#sum >>= 1;
	
twisted_sum_array_plus:
	sll	$t5, $t2, 2	#4*(i)
	add	$t4, $a0, $t5	#v+4i
	lw	$t6, 0($t4)	#v[i]
	add	$v0, $v0, $t6	#sum += v[i];
	add	$t2, $t2, 1	#i++
	j	twisted_sum_array_loop
twisted_sum_array_return:
	
	jr	$ra
