.data

# Strings for printing purposes
get_num_carrots_n1_str:
.asciiz "get_num_carrots test case 1 is: "
get_num_carrots_n2_str:
.asciiz "get_num_carrots test case 2 is: "

node1: .word 0 0 0x1ff00ff 0 0 0 0 0 0 0
node2: .word 0 0xffffff 0xff00 0 0 0 0 0 0 0
.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, get_num_carrots_n1_str
	jal	print_string
	la	$a0, node1
	jal	get_num_carrots
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, get_num_carrots_n2_str
	jal	print_string
	la	$a0, node2
	jal	get_num_carrots
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
