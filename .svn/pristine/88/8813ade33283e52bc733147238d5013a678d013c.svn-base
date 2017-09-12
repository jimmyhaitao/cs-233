.data

# Strings for printing purposes
detect_parity_0_str: .asciiz "detect_parity(0) is: "
detect_parity_233_str: .asciiz "detect_parity(233) is: "

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, detect_parity_0_str
	jal	print_string
	li	$a0, 0
	jal	detect_parity
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, detect_parity_233_str
	jal	print_string
	li	$a0, 233
	jal	detect_parity
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
