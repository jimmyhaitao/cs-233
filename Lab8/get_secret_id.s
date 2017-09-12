.text

## int
## get_secret_id(int k, Baskets *baskets) {
##     if (baskets == NULL) {
##         return 0;
##     }
##     int secret_id = 0;
##     for (int i = 0; i < k; i++) {
##         secret_id += calculate_identity(baskets->basket[i]->identity,
##                                         baskets->basket[i]->id_size);
##     }
##     return secret_id;
## }
## 
## struct Node {
##     char seen;	4
##     int basket;	4
##     int dirt;	4
##     int id_size;	4
##     int *identity;	4
##     int num_children;4
##     Node *children[4];4*4
## };
## 
## struct Baskets {
##     int num_found;
##     Node *basket[10];
## };

.globl get_secret_id
get_secret_id:
	# Your code goes here :)
	bne	$a1, $0, get_secret_id_notNULL
	jr	$ra
	
get_secret_id_notNULL:
	sub	$sp, $sp, 20	
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	
	li	$s0, 0			#s0:secret_id=0
	li 	$s1, 0			#s1:i=0
	move	$s2, $a0		#s2:k
	move	$s3, $a1		#s3:baskets
get_secret_id_forloop:
	bge	$s1, $s2, get_secret_id_end
	add	$t0, $s3, 4		#t0=&baskets->basket
	sll	$t1, $s1, 2		#t1=4*i
	add	$t0, $t1, $t0		#t0=&baskets->basket[i]		t1 could be reused
	lw	$t0, 0($t0)		#t0=baskets->basket[i]->seen
	add	$t1, $t0, 16		#t1=&baskets->basket[i]->identity
	lw	$a0, 0($t1)		#a0=baskets->basket[i]->identity
	add	$t0, $t0, 12		#t0=&baskets->basket[i]->id_size
	lw	$a1, 0($t0)		#a0=baskets->basket[i]->id_size
	jal	calculate_identity
	add	$s0, $s0, $v0		
	add	$s1, $s1, 1		#s1:i++
	j	get_secret_id_forloop
get_secret_id_end:
	move	$v0, $s0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20
	jr  $ra
