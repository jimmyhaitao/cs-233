.data

# Strings for printing purposes
twisted_sum_array_even_str:
.asciiz "twisted_sum_array(even_array, 4) is: "
twisted_sum_array_odd_str:
.asciiz "twisted_sum_array(odd_array, 4) is: "

# Arrays
even_array: .word 2 4 6 8
odd_array: .word 1 3 5 7
ARRAY_LEN = 4

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, twisted_sum_array_even_str
	jal	print_string
	la	$a0, even_array
	li	$a1, ARRAY_LEN
	jal	twisted_sum_array
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, twisted_sum_array_odd_str
	jal	print_string
	la	$a0, odd_array
	li	$a1, ARRAY_LEN
	jal	twisted_sum_array
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
