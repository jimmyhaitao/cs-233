
.text
# For the two following functions from Lab7.2,
# we highly recommend that you copy in our 
# solutions when it is released on Tuesday night 
# after the late deadline for Lab7.2
#
# If you reach this part before Tuesday night,
# you can paste your Lab7.2 solution here for now

.globl accumulate
accumulate:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

	move	$s0, $a0
	move	$s1, $a1

	jal	max_conts_bits_in_common
	blt	$v0, 2, a_dp
	or	$v0, $s0, $s1
	j	a_ret

a_dp:
	move	$a0, $s1
	jal	detect_parity
	bne	$v0, 0, a_mul
	add	$v0, $s0, $s1
	j	a_ret

a_mul:
	mul	$v0, $s0, $s1

a_ret:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	jr	$ra

.globl calculate_identity
calculate_identity:
	sub	$sp, $sp, 36
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)

	move	$s0, $a0		# $s0 = int *v
	move	$s1, $a1		# $s1 = int size

	move	$s2, $s1		# $s2 = int dist = size
	move	$s3, $0			# $s3 = int total = 0
	li	$s4, -1			# $s4 = int idx = -1

	sw	$s1, turns+4		# turns[1] = size
	mul	$t0, $s1, $s4		# -size
	sw	$t0, turns+12		# turns[3] = -size

ci_while:
	ble	$s2, 0, ci_done		# if (dist <= 0), done

	li	$s5, 0			# $s5 = int i = 0
ci_for_i:
	bge	$s5, 4, ci_while 	# if (i >= 4), done

	li	$s6, 0			# $s6 = int j = 0
ci_for_j:
	bge	$s6, $s2, ci_for_j_done # if (j >= dist), dine

	la	$t1, turns
	mul	$t0, $s5, 4
	add	$t0, $t0, $t1		# &turns[i]
	lw	$t0, 0($t0)		# turns[i]
	add	$s4, $s4, $t0		# idx = idx + turns[i]

	move	$a0, $s3		# total

	mul	$s7, $s4, 4
	add	$s7, $s7, $s0		# &v[idx]
	lw	$a1, 0($s7)		# v[idx]

	jal	accumulate		# accumulate(total, v[idx])
	move	$s3, $v0		# total = accumulate(total, v[idx])
	sw	$s3, 0($s7)		# v[idx] = total

	add	$s6, $s6, 1		# j++
	j	ci_for_j

ci_for_j_done:
	rem	$t0, $s5, 2		# i % 2
	bne	$t0, 0, ci_skip		# if (i % 2 != 0), skip
	sub	$s2, $s2, 1		# dist--

ci_skip:
	add	$s5, $s5, 1		# i++
	j	ci_for_i

ci_done:
	move	$a0, $s0		# v
	mul	$a1, $s1, $s1		# size * size
	jal	twisted_sum_array	# twisted_sum_array(v, size * size)

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

##########################################################
#################### Lab7.1 functions ####################
##########################################################

.globl detect_parity
detect_parity:
	li	$t1, 0			# $t1 = int bits_counted = 0
	li	$v0, 1			# $v0 = int return_value = 1

	li	$t0, 0			# $t0 = int i = 0
dp_for:
	bge	$t0, 32, dp_done	# if (i >= INT_SIZE), done

	sra	$t3, $a0, $t0		# number >> i
	and	$t3, $t3, 1		# $t3 = int bit = (number >> i) & 1

	beq	$t3, 0, dp_skip		# if (bit == 0), skip
	add	$t1, $t1, 1		# bits_counted++

dp_skip:
	add	$t0, $t0, 1		# i++
	j	dp_for

dp_done:
	rem	$t3, $t1, 2		# bits_counted % 2
	beq	$t3, 0, dp_ret		# if (bits_counted % 2 == 0), skip
	li	$v0, 0			# return_value = 0

dp_ret:
	jr	$ra			# $v0 is already return_value

.globl max_conts_bits_in_common
max_conts_bits_in_common:
	li	$t1, 0			# $t1 = int bits_seen = 0
	li	$v0, 0			# $v0 = int max_seen = 0
	and	$t2, $a0, $a1		# $t2 = int c = a & b

	li	$t0, 0			# $t0 = int i = 0
mcbic_for:
	bge	$t0, 32, mcbic_done	# if (i >= INT_SIZE), done

	sra	$t3, $t2, $t0		# c >> i
	and	$t3, $t3, 1		# $t3 = int bit = (c >> i) & 1

	beq	$t3, 0, mcbic_else 	# if (bit == 0), else
	add	$t1, $t1, 1		# bits_seen++
	j	mcbic_cont

mcbic_else:
	ble	$t1, $v0, mcbic_skip 	# if (bit_seen <= max_seen), skip
	move	$v0, $t1		# max_seen = bits_seen

mcbic_skip:
	li	$t1, 0			# bits_seen = 0

mcbic_cont:
	add	$t0, $t0, 1		# i++
	j	mcbic_for

mcbic_done:
	ble	$t1, $v0, mcbic_ret 	# if (bits_seen <= max_seen), skip
	move	$v0, $t1		# max_seen = bits_seen

mcbic_ret:
	jr	$ra			# $v0 is already max_seen

.globl twisted_sum_array
twisted_sum_array:
	li	$v0, 0			# $v0 = int sum = 0

	li	$t0, 0			# $t0 = int i = 0
tsa_for:
	bge	$t0, $a1, tsa_done	# if (i >= length), done

	sub	$t1, $a1, 1		# length - 1
	sub	$t1, $t1, $t0		# length - 1 - i
	mul	$t1, $t1, 4
	add	$t1, $t1, $a0		# &v[length - 1 - i]
	lw	$t2, 0($t1)		# v[length - 1 - i]
	and	$t2, $t2, 1		# v[length - 1 - i] & 1

	beq	$t2, 0, tsa_skip	# if (v[length - 1 - i] & 1 == 0), skip
	sra	$v0, $v0, 1		# sum >>= 1

tsa_skip:
	mul	$t1, $t0, 4
	add	$t1, $t1, $a0		# &v[i]
	lw	$t2, 0($t1)		# v[i]
	add	$v0, $v0, $t2		# sum += v[i]

	add	$t0, $t0, 1		# i++
	j	tsa_for

tsa_done:
	jr	$ra			# $v0 is already sum
