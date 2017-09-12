.data

# Strings for printing purposes
max_conts_bits_in_common_10_5_str:
.asciiz "max_conts_bits_in_common(10, 5) is: "
max_conts_bits_in_common_237_239_str:
.asciiz "max_conts_bits_in_common(237, 239) is: "

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, max_conts_bits_in_common_10_5_str
	jal	print_string
	li	$a0, 10
	li	$a1, 5
	jal	max_conts_bits_in_common
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, max_conts_bits_in_common_237_239_str
	jal	print_string
	li	$a0, 237
	li	$a1, 239
	jal	max_conts_bits_in_common
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
