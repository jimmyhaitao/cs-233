# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_4.s

# void array_swap(int *A, int a_length, int *B, int b_length) {
#     int length = a_length;
#     if (b_length < a_length) {
#         length = b_length;
#     }
# 
#     for (int i = 0; i < length; i++) {
#         int temp = A[i];
#         A[i] = B[i];
#         B[i] = temp;
#     }
# }
.globl array_swap
array_swap:
	move	$t0, $a1		#t0:length = a_length;
	bge	$a3, $t0, afterif	#if (b_length < a_length) {
	move 	$t0, $a3		#t0: length = b_length;

afterif:
	li	$t1, 0			#t1:i=0

loop:
	bge	$t1, $t0, end		#length = b_length;
	sll	$t2, $t1, 2		#t2=i*4

	add	$t3, $t2, $a0		#t3=i*4+A
	lw	$t4, 0($t3)		#t4:temp = A[i];

	add	$t5, $t2, $a2		#t5=i*4+B
	lw	$t6, 0($t5)		#t6=B[i];
	sw	$t6, 0($t3)		#A[i] = B[i];
	sw	$t4, 0($t5)		#B[i] = temp;
	
	add	$t1, $t1, 1		#i++
	j	loop
end:
	jr	$ra
