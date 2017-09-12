# run with QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *children[4];
#     int data;
# };
# 
# node_t *find_maximum_node(node_t *node) {
#     node_t *max = node;
#     for (int i = 0; i < 4; i++) {
#         if (node->children[i] != NULL) {
#             node_t *max_of_child = find_maximum_node(node->children[i]);
#             if (max_of_child->data > max->data) {
#                 max = max_of_child;
#             }
#         }
#     }
#     return max;
# }
.globl find_maximum_node
find_maximum_node:
	sub		$sp,$sp,24
	sw		$ra,0($sp)
	sw		$s0,4($sp)
	sw		$s1,8($sp)
	sw		$s2,12($sp)
	sw		$s3,16($sp)
	sw		$s4,20($sp)
	move		$s0, $a0	#s0:node
	move		$s1, $a0	#s1:max=node	
	li		$s2, 0		#s2:i=0
	
for_loop:
	bge		$s2, 4, return
	sll		$s3, $s2, 2	#i*4
	add		$s3, $s3, $s0	#node+i*4
	lw		$s3, 0($s3)
	beq		$s3, 0, after_if
	move		$a0, $s3
	jal		find_maximum_node
	lw		$s3, 16($v0)
	lw		$s4, 16($s1)
	ble		$s3, $s4,after_if
	move		$s1, $v0
	
after_if:
	add		$s2,$s2,1	#i++
	j		for_loop
return:
	move		$v0, $s1
	lw		$ra,0($sp)
	lw		$s0,4($sp)
	lw		$s1,8($sp)
	lw		$s2,12($sp)
	lw		$s3,16($sp)
	lw		$s4,20($sp)
	add		$sp,$sp,24
	jr		$ra
