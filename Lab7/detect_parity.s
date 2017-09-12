.text

## int
## detect_parity(int number) {
##     int bits_counted = 0;
##     int return_value = 1;
##     for (int i = 0; i < INT_SIZE; i++) {
##         int bit = (number >> i) & 1;
##         // zero is false, anything else is true
##         if (bit) { 
##             bits_counted++;
##         }
##     }
##     if (bits_counted % 2 != 0) {
##         return_value = 0;
##     }
##     return return_value;
## }

.globl detect_parity
detect_parity:
	# Your code goes here :)
	li	$t1, 0			#bits_counted=0
	li	$v0, 1			#return_value=1
	li	$t3, 0			#i=0
detect_parity_loop:
	bge $t3, 32, detect_parity_if	#go to if statement
	srl $t4, $a0, $t3	#number>>i
	andi $t5, $t4, 1	#(number >> i) & 1;
	beq $t5, 0, detect_parity_jump	#if(bit)
	add $t1, $t1, 1	#bits_counted++
	
detect_parity_jump:	
	add $t3, $t3, 1	#i++
	j detect_parity_loop

	
detect_parity_if:
	and $t2, $t1, 1	#bits_counted=bits_counted%2
	beq $t2, 0, detect_parity_end
	li $v0, 0	#return_value=0
	
detect_parity_end:
	jr	$ra
