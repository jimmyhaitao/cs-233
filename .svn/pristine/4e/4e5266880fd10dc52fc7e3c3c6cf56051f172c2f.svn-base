.data

# Strings for printing purposes
calculate_identity_two_by_two_str:
.asciiz "calculate_identity(two_by_two_mat, 2) is: "
calculate_identity_five_by_five_str:
.asciiz "calculate_identity(five_by_five_mat, 5) is: "

# Arrays
.globl turns
turns: .word 1 0 -1 0
two_by_two_mat: .word 1 2 3 4
five_by_five_mat: .word 0 1 2 3 7 41 5 63 7 2 2 8 2 4 1 42 5 6 1 450 8 9 10 11 25
TWO_BY_TWO_LEN = 2
FIVE_BY_FIVE_LEN = 5

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, calculate_identity_two_by_two_str
	jal	print_string
	la	$a0, two_by_two_mat
	li	$a1, TWO_BY_TWO_LEN
	jal	calculate_identity
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, calculate_identity_five_by_five_str
	jal	print_string
	la	$a0, five_by_five_mat
	li	$a1, FIVE_BY_FIVE_LEN
	jal	calculate_identity
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
