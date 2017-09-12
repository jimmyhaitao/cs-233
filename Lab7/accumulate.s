.text

## int
## accumulate(int total, int value) {
##     if (max_conts_bits_in_common(total, value) >= 2) {
##         total = total | value;
##     } else if (detect_parity(value) == 0) {
##         total = total + value;
##     } else {
##         total = total * value;
##     }
##     return total;
## }

.globl accumulate
accumulate:
	# Your code goes here :)
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)	
	sw	$s0, 4($sp)	
	sw	$s1, 8($sp)	
	#after initiatlize
	move	$s0, $a0 	#store total
	move	$s1, $a1 	#store value
	#move	$t0, $a0 	#store total to $t0
	#move	$t1, $a1	#store value to $t0
	jal	max_conts_bits_in_common	#call the function
	blt	$v0, 2, accumulate_elseif	#if (max_conts_bits_in_common(total, value) >= 2) 	
	or	$s0, $s0, $s1	#total = total | value;
	j	accumulate_end	#return
	
accumulate_elseif:
	move	$a0, $s1	#a0=value
	jal	detect_parity	#detect_parity(value)
	bne	$v0, 0, accumulate_else	#detect_parity(value) == 0
	#move	$a0, $s0
	#move	$a1, $s1	
	add	$s0, $s0, $s1	#total = total + value;
	j	accumulate_end	#return
	
accumulate_else:
	mult	$s0, $s1	#total = total * value;
	mflo	$s0
		
accumulate_end:
	move	$v0, $s0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	jr	$ra
