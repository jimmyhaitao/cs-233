.data

# Strings for printing purposes
get_secret_id_2_four_baskets_str:
.asciiz "get_secret_id(2, four_baskets) is: "
get_secret_id_4_four_baskets_str:
.asciiz "get_secret_id(4, four_baskets) is: "

.globl turns
turns: .word 1 0 -1 0

node1: .word 0 0 0x1ff00ff 1 identity1 0 0 0 0 0
node2: .word 0 0 0x2ff00ff 1 identity2 0 0 0 0 0
node3: .word 0 0 0x3ff00ff 1 identity3 0 0 0 0 0
node4: .word 0 0 0x4ff00ff 1 identity4 0 0 0 0 0
identity1: .word 1
identity2: .word 2
identity3: .word 3
identity4: .word 4
basket4: .word 4 node1 node2 node3 node4 0 0 0 0 0 0 


.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, get_secret_id_2_four_baskets_str
	jal	print_string
	li  $a0, 2
	la	$a1, basket4
	jal	get_secret_id
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, get_secret_id_4_four_baskets_str
	jal	print_string
	li  $a0, 4
	la	$a1, basket4
	jal	get_secret_id
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
