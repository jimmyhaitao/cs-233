# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *left;
#     node_t *right;
#     int data;
# };
# 
# void tree_sort(node_t *root) {
#     if (root == NULL) {
#         return;
#     }
# 
#     if (root->right != NULL) {
#         if (root->left == NULL || (root->right->data < root->left->data)) {
#             node_t *temp = root->left;
#             root->left = root->right;
#             root->right = temp;
#         }
#     }
# 
#     tree_sort(root->left);
#     tree_sort(root->right);
# }
.globl tree_sort
tree_sort:
	sub	$sp,$sp,28
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	sw	$s2,12($sp)
	sw	$s3,16($sp)
	sw	$s4,20($sp)
	sw	$s5,24($sp)
	
	move	$s0, $a0	#s0:root
	beq	$s0, 0, return
	
	lw	$s1, 4($s0)	#s1:root->right
	lw	$s2, 0($s0)	#s2:root->left
	beq	$s1, 0, after_if
	bne	$s2, 0, second_state
	j	in_if
	
second_state:
	lw	$s3, 8($s1)	#s3:root->right->data
	lw	$s4, 8($s2)	#s4:root->left->data
	bge	$s3, $s4, after_if
	
in_if:
	lw	$s5, 0($s0)	#s5:temp=root->left
	sw	$s1, 0($s0)	#root->left = root->right;
	sw	$s5,4($s0)	#root->right = temp;
	
after_if:	
	move	$a0, $s2
	jal	tree_sort
	move	$a0, $s1
	jal	tree_sort
	
return:
	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)
	lw	$s4,20($sp)
	lw	$s5,24($sp)
	add	$sp,$sp,28
	jr	$ra
	
