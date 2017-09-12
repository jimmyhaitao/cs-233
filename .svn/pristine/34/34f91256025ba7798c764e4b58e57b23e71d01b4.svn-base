# Various helper functions for printing things
.data
digit_lookup: .ascii "0123456789abcdef"
hex_start_str: .asciiz "0x"
word_str: .asciiz ".word"

# Syscall constants
PRINT_INT = 1
PRINT_STRING = 4
PRINT_CHAR = 11

.text
# print node ##################################################
#
# argument $a0: address of node
# returns       nothing
.globl print_node
print_node:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)		# save $ra
	move $a1, $a0

	jal print_int_hex_and_space
	li $a0, ':'
	jal print_char_and_space

	la $a0, word_str
	jal print_string
	jal print_space

	lb 	 $a0, 0($a1)
	jal print_int_and_space

	lw 	 $a0, 4($a1)
	jal print_int_and_space
	lw 	 $a0, 8($a1)
	jal print_int_and_space
	lw 	 $a0, 12($a1)
	jal print_int_and_space
	lw 	 $a0, 16($a1)
	jal print_int_hex_and_space
	lw 	 $a0, 20($a1)
	jal print_int_and_space

	lw 	 $a0, 24($a1)
	jal print_int_hex_and_space
	lw 	 $a0, 28($a1)
	jal print_int_hex_and_space
	lw 	 $a0, 32($a1)
	jal print_int_hex_and_space
	lw 	 $a0, 36($a1)
	jal print_int_hex_and_space
	
	lw	$ra, 0($sp)		# save $ra
	add	$sp, $sp, 4
	jr	$ra		# return to the calling procedure


# print baskets ##################################################
#
# argument $a0: address of basket
# returns       nothing

.globl print_baskets
print_baskets:
	sub	$sp, $sp, 16
	li  $t0, 0 			# i = 0

	sw	$ra, 0($sp)		# save $ra
	sw 	$a0, 4($sp)		# save &baskets
	sw  $t0, 8($sp) 	# save i
	lw  $a0, 0($a0)		# num_found
	sw 	$a0, 12($sp)	# save num_found
	jal print_newline
	lw 	$a0, 4($sp)		# restore &baskets
	lw  $t0, 8($sp) 	# restore i
	lw 	$t1, 12($sp)	# restore num_found

pb_loop:
	bge $t0, $t1, pb_done
	sw 	$a0, 4($sp)		# save &baskets
	sw  $t0, 8($sp) 	#  save i
	mul $t2, $t0, 4 	# 4*i
	add $t2, $a0, $t2 	# baskets[i-1]
	lw  $a0, 4($t2)   	# baskets[i]
	jal print_node
	jal print_newline
	lw 	$a0, 4($sp)		# restore &baskets
	lw  $t0, 8($sp) 	# restore i
	lw 	$t1, 12($sp)	# restore num_found

	add $t0, $t0, 1 	# i = i + 1
	j pb_loop
pb_done:
	lw	$ra, 0($sp)
	add	$sp, $sp, 16
	jr $ra





	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure



# print int and space ##################################################
#
# argument $a0: number to print
# returns       nothing

.globl print_int_and_space
print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure



# print space ##################################################
#
# argument 		nothing
# returns       nothing

.globl print_space
print_space:
	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print int in hexadecimal and space ###################################
#
# argument $a0: number to print
# returns       nothing

DIGIT_MASK = 0xf0000000

.globl print_int_hex_and_space
print_int_hex_and_space:
	move	$t0, $a0		# $t0 = number

	la	$a0, hex_start_str	# Always print out "0x"
	li	$v0, PRINT_STRING
	syscall

	bnez	$t0, pihas_not_zero	# if (number == 0x0)
	li	$a0, '0'		# print "0"
	li	$v0, PRINT_CHAR
	syscall
	j	pihas_print_space

pihas_not_zero:
	li	$t1, 8			# $t1 = digits_remain = 8

pihas_lead_zero_loop:
	and	$t2, $t0, DIGIT_MASK	# mask out everything except first digit
	bnez	$t2, pihas_print_loop	# while (!(number & digit_mask))
	sll	$t0, $t0, 4		# number <<= 4
	sub	$t1, $t1, 1		# --digits_remain
	j	pihas_lead_zero_loop

pihas_print_loop:
	blez	$t1, pihas_print_space	# while (digits_remain > 0)

	srl	$a0, $t0, 28		# print digit_lookup[number >> 28]
	lb	$a0, digit_lookup($a0)
	li	$v0, PRINT_CHAR
	syscall

	sub	$t1, $t1, 1		# --digits_remain
	sll	$t0, $t0, 4		# number <<= 4
	j	pihas_print_loop

pihas_print_space:
	li   	$a0, ' '
	li	$v0, PRINT_CHAR
	syscall

	jr	$ra

# print char and space #################################################
#
# argument $a0: character to print
# returns       nothing

.globl print_char_and_space
print_char_and_space:
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print string #########################################################
#
# argument $a0: string to print
# returns       nothing

.globl print_string
print_string:
	li	$v0, PRINT_STRING	# print string command
	syscall	     			# string is in $a0
	jr	$ra

# print newline ########################################################
#
# no arguments
# returns       nothing

.globl print_newline
print_newline:
	li   	$a0, '\n'      	# print a newline
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	jr	$ra

