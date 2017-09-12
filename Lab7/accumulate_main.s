.data

# Strings for printing purposes
accumulate_13_15_str:
.asciiz "accumulate(13, 15) is: "
accumulate_42_21_str:
.asciiz "accumulate(42, 21) is: "
accumulate_10_15_str:
.asciiz "accumulate(10, 15) is: "

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, accumulate_13_15_str
	jal	print_string
	li	$a0, 13
	li	$a1, 15
	jal	accumulate
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, accumulate_42_21_str
	jal	print_string
	li	$a0, 42
	li	$a1, 21
	jal	accumulate
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, accumulate_10_15_str
	jal	print_string
	li	$a0, 10
	li	$a1, 15
	jal	accumulate
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
