.data

# Strings for printing purposes
collect_baskets_3_n5_two_baskets_str:
.asciiz "collect_baskets(3, n5, two_baskets) is: "
collect_baskets_4_n9_four_baskets_str:
.asciiz "collect_baskets(4, n9, four_baskets) is: "

.globl turns
turns: .word 1 0 -1 0

node1: .word 0 0 0x1ff00ff 0 0 0 0 0 0 0
node2: .word 0 0 0x2ff00ff 0 0 0 0 0 0 0
node3: .word 0 0 0x3ff00ff 0 0 2 node1 node2 0 0
node4: .word 0 0 0x4ff00ff 0 0 0 0 0 0 0
node5: .word 0 0 0x5ff00ff 0 0 2 node3 node4 0 0

node6: .word 0 0 0x1ff00ff 0 0 0 0 0 0 0
node7: .word 0 0 0x2ff00ff 0 0 1 node6 0 0 0
node8: .word 0 0 0x3ff00ff 0 0 1 node6 0 0 0
node9: .word 0 0 0x4ff00ff 0 0 2 node7 node8 0 0

basket2: .word 0 0 0 0 0 0 0 0 0 0 0 
basket4: .word 0 0 0 0 0 0 0 0 0 0 0 

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, collect_baskets_3_n5_two_baskets_str
	jal	print_string
	li  $a0, 3
	la	$a1, node5
	la  $a2, basket2
	jal	collect_baskets
	la  $a0, basket2
	jal	print_baskets
	jal	print_newline

	la	$a0, collect_baskets_4_n9_four_baskets_str
	jal	print_string
	li  $a0, 4
	la	$a1, node9
	la  $a2, basket4
	jal	collect_baskets
	move	$a0, $v0
	la  $a0, basket4
	jal	print_baskets
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
