# run with QtSpim -file main.s question_4.s

# void swap_pairs(int *array, int length) {
#     length = length & ~1;
# 
#     for (int i = 0; i < length; i += 2) {
#         int temp = array[i];
#         array[i] = array[i + 1];
#         array[i + 1] = temp;
#     }
# }
.globl swap_pairs
swap_pairs:
	li	$t0, 1
	not	$t0, $t0		#
	and	$a1, $a1, $t0		#a1:length = length & ~1;
	li	$t0, 0			#t0:i=0
	
loop:
	bge	$t0, $a1, end
	sll	$t1, $t0, 2		#t1:i*4
	add	$t1, $t1, $a0		#t1=array+i*4
	lw	$t2, 0($t1)		#t2:temp=array[i]
	lw	$t3, 4($t1)		#t3=array[i + 1]
	sw	$t3, 0($t1)		#array[i] = array[i + 1];
	sw	$t2, 4($t1)		#array[i + 1] = temp;
	add	$t0, $t0, 2		#i+=2
	j	loop			#
end:
	jr	$ra
