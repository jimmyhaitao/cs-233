
calculate_identity:
	# Your code goes here :)
	sub		$sp, $sp, 36
	sw		$ra, 0($sp)	
	sw		$s0, 4($sp)	
	sw		$s1, 8($sp)
	sw		$s2, 12($sp)
	sw		$s3, 16($sp)
	sw		$s4, 20($sp)
	sw		$s5, 24($sp)
	sw		$s6, 28($sp)
	sw		$s7, 32($sp)
	move	$s0, $a0 		#	$s0:v
	move	$s1, $a1 		#	$s1:size
	la		$t0, turns		#store turns to t0
	move	$t1, $s1		#	$t1: dist = size;
	li		$t2, 0			#	$t2 total = 0;
	li		$t3, -1			#	$t3 idx = -1;
	sw		$s1, 4($t0)		#turns[1] = size;
	sub		$t4, $0, $s1	#t4=-size
	sw		$t4, 12($t0)	#turns[3] = -size;

calculate_identity_loop:
	ble		$t1, 0, calculate_identity_end	
	li		$t5, 0			#i=0
calculate_identity_loop2:
	bge		$t5, 4, calculate_identity_loop	#go to while if i >=4
	li		$t6, 0			#j=0
calculate_identity_loop3:
	bge		$t6, $t1, calculate_identity_insideloop		#go to the 'if' part
	sll		$t7, $t5, 2		#4*i
	la		$t0,turns
	add		$t7, $t7, $t0	#t7=turns+4i
	lw		$t7, 0($t7)	#t7=turns[i]
	add		$t3, $t7, $t3	# idx=idx + turns[i];	
	#set argument for fxn call
	move	$a0, $t2		#a0=total
	sll		$t8, $t3, 2		#4idx
	add		$t8, $t8, $s0	#v+4dix
	lw		$t7, 0($t8)		#t7=v[idx]
	move	$a1, $t7		#a1=v[idx]
		#store
	move	$s2, $t1
	move	$s3, $t2
	move	$s4, $t3
	move	$s5, $t5
	move	$s6, $t6
	move	$s7, $t8
	jal	accumulate			#accumulate(total, v[idx])
	move	$t1, $s2
	move	$t2, $s3
	move	$t3, $s4
	move	$t5, $s5
	move	$t6, $s6
	move	$t8, $s7
		#store
	move	$t2, $v0		#total = accumulate(total, v[idx]);
	sw		$t2, 0($t8)		#v[idx] = total;
	add		$t6, $t6, 1		#j++
	j	calculate_identity_loop3	#for loop2
calculate_identity_insideloop:
	#need if and dist-- here
	li		$t9, 2
	div		$t5, $t9		#i % 2
	mfhi	$t7				#t7=i%2
	bne		$t7, 0, calculate_identity_if	#branch and jump to forloop 1
	sub		$t1, $t1,1		#dist--;
	
calculate_identity_if:
	add	$t5, $t5, 1			#i++
	j	calculate_identity_loop2	#for loop1
	
calculate_identity_end:	
#need return here
	move	$a0, $s0
	mult	$s1, $s1
	mflo	$a1
	jal 	twisted_sum_array	#twisted_sum_array(v, size * size);
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	add	$sp, $sp, 36
	jr	$ra
	
	
	
