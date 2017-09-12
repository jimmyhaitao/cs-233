# run with QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *left;
#     node_t *right;
#     int *data;
# };
# int total_tree(node_t *root) {
#     if (root == NULL) {
#         return 0;
#     }
# 
#     int total = 0;
#     if (root->data != NULL) {
#         total += *(root->data);
#     }
# 
#     total += total_tree(root->left);
#     total += total_tree(root->right);
# 
#     return total;
# }
.globl total_tree
total_tree:
	sub		$sp, $sp, 16
	sw		$ra, 0($sp)	
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	sw		$s2, 12($sp)
	move		$s2, $a0
	bne		$s2, $zero, not_null
	li		$v0, 0
	j		return
	
not_null:
	li		$s0, 0		#s0:total=0
	lw		$s1, 8($s2)	#s1:root->data
	beq		$s1, 0, is_null #
	lw		$s1, 0($s1)	#s1:*(root->data)
	add		$s0, $s0, $s1	# total += *(root->data);
is_null:
	
	lw		$a0, 0($s2)	
	jal		total_tree
	add		$s0, $s0, $v0
	lw		$a0, 4($s2)	
	jal		total_tree
	add		$s0, $s0, $v0
	move		$v0, $s0

return:
	lw		$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	lw		$s2, 12($sp)
	add		$sp, $sp, 16
	jr		$ra
