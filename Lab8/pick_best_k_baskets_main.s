.data

# Strings for printing purposes
pick_best_k_baskets_n1_str:
.asciiz "pick_best_k_baskets(4, four_baskets) is: "
pick_best_k_baskets_n2_str:
.asciiz "pick_best_k_baskets(4, eight_baskets) is: "

node1: .word 0 0 0x1ff00ff 0 0 0 0 0 0 0
node2: .word 0 0 0x2ff00ff 0 0 0 0 0 0 0
node3: .word 0 0 0x3ff00ff 0 0 0 0 0 0 0
node4: .word 0 0 0x4ff00ff 0 0 0 0 0 0 0
node5: .word 0 0 0x5ff00ff 0 0 0 0 0 0 0
node6: .word 0 0 0x6ff00ff 0 0 0 0 0 0 0
node7: .word 0 0 0x7ff00ff 0 0 0 0 0 0 0
node8: .word 0 0 0x8ff00ff 0 0 0 0 0 0 0

basket4: .word 4 node1 node2 node3 node4 0 0 0 0 0 0 
basket8: .word 8 node1 node3 node5 node7 node2 node4 node6 node8 0 0

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, pick_best_k_baskets_n1_str
	jal	print_string
	li  $a0, 4
	la	$a1, basket4
	jal	pick_best_k_baskets
	la	$a0, basket4
	jal	print_baskets
	jal	print_newline

	la	$a0, pick_best_k_baskets_n2_str
	jal	print_string
	li  $a0, 4
	la	$a1, basket8
	jal	pick_best_k_baskets
	la	$a0, basket8
	jal	print_baskets
	jal	print_newline


	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
