.text

## int
## search_carrot(int max_baskets, int k, Node *root, Baskets *baskets) {
##     if (root == NULL || baskets == NULL) {
##         return 0;
##     }
##     baskets->num_found = 0;
##     for (int i = 0; i < max_baskets; i++) {
##         baskets->basket[i] = NULL;
##     }
##     collect_baskets(max_baskets, root, baskets);
##     pick_best_k_baskets(k, baskets);
##     return get_secret_id(k, baskets);
## }
## 
## struct Node {
##     char seen;
##     int basket;
##     int dirt;
##     int id_size;
##     int *identity;
##     int num_children;
##     Node *children[4];
## };
## 
## struct Baskets {
##     int num_found;
##     Node *basket[10];
## };

.globl search_carrot
search_carrot:
	# Your code goes here :)
	bne	$a0, $0, search_carrot_NULL2
	jr	$ra
search_carrot_NULL2:
	bne	$a1, $0, search_carrot_afterNULL
	jr	$ra
search_carrot_afterNULL:
	sub	$sp, $sp, 24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	move	$s0, $a0			#s0:max_baskets
	move	$s1, $a1			#s1:k
	move	$s2, $a2			#s2:root
	move	$s3, $a3			#s3:baskets
	sw	$0, 0($s3)			#baskets->num_found = 0;
	li	$s4, 0				#s4:i=0
search_carrot_forloop:
	bge	$s4, $s0, search_carrot_afterloop
	sll	$t0, $s4, 2			#t0=i*4
	add	$t0, $t0, 4			#t0=i*4+4
	add	$t0, $t0, $s3			#t0=&baskets->basket[i]
	sw	$0, 0($t0)			#baskets->basket[i] = NULL;	t0 could be reused
	add	$s4, $s4, 1			#i++
	j	search_carrot_forloop
search_carrot_afterloop:
	move	$a0, $s0
	move	$a1, $s2
	move	$a2, $s3
	jal	collect_baskets
	move	$a0, $s1
	move	$a1, $s3
	jal	pick_best_k_baskets
	move	$a0, $s1
	move	$a1, $s3
	jal	get_secret_id
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra
