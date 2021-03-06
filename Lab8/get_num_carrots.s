.text

## struct Node {
##     char seen;	4
##     int basket;	4
##     int dirt;	4
##     int id_size;	4
##     int *identity;	4
##     int num_children;	4
##     Node *children[4];	4 * 4
## };
##
## int
## get_num_carrots(Node *spot) {
##     if (spot == NULL) {
##         return 0;
##     }
##     // Inverts the first and third byte.
##     unsigned int dig = spot->dirt ^ 0x00ff00ff;
##     // Circular shifts the bytes left one.
##     dig = ((dig & 0xffffff) << 8) | ((dig & 0xff000000) >> 24);
##     return spot->basket ^ dig;
## }

.globl get_num_carrots
get_num_carrots:
	# Your code goes here :)
	bne	$a0, $0, get_num_carrots_after_NULL
	li	$v0, 0
	jr	$ra		#return 0
	
get_num_carrots_after_NULL:
	lw	$t0, 8($a0)		#t0=(spot->dirt)
	xor	$t0, $t0, 0x00ff00ff	#t0:dig=spot->dirt ^ 0x00ff00ff
	and	$t1, $t0, 0xffffff	#t1=dig & 0xffffff
	sll	$t1, $t1, 8		#t1=(dig & 0xffffff) << 8
	and	$t2, $t0, 0xff000000	#t2=dig & 0xff000000
	sra	$t2, $t2, 24		#(dig & 0xff000000) >> 24
	or	$t0, $t1, $t2		#t0: dig = ((dig & 0xffffff) << 8)|((dig & 0xff000000) >> 24);
	lw	$v0, 4($a0)		#v0=spot->basket
	xor	$v0, $v0, $t0		#v0= spot->basket ^ dig
	jr	$ra
