.text

## void
## collect_baskets(int max_baskets, Node *spot, Baskets *baskets) {
##     if (spot == NULL || baskets == NULL || spot->seen == 1) {
##         return;
##     }
##     spot->seen = 1;
##     for (int i = 0; i < spot->num_children && baskets->num_found < max_baskets;
##          i++) {
##         collect_baskets(max_baskets, spot->children[i], baskets);
##     }
##     if (baskets->num_found < max_baskets && get_num_carrots(spot) > 0) {
##         baskets->basket[baskets->num_found] = spot;
##         baskets->num_found++;
##     }
##     return;
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
##     int num_found;		4
##     Node *basket[10];	4*10
## };

.globl collect_baskets
collect_baskets:
	# Your code goes here :)
	bne	$a1, $0, collect_baskets_null2
	jr	$ra
	
collect_baskets_null2:
	bne	$a2, $0, collect_baskets_null3
	jr	$ra
	
collect_baskets_null3:
	lb	$t0, 0($a1)				#$t0=spot->seen
	bne	$t0, 1, collect_baskets_afterNULL	#t0 could be reused
	jr	$ra
collect_baskets_afterNULL:
	sub	$sp, $sp, 20		
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	move	$s0, $a0			#s0:max_baskets
	move	$s1, $a1			#s1,spot
	move	$s2, $a2			#s2:baskets
	li	$t0, 1
	sb	$t0, 0($s1)			#spot->seen = 1;	t0 could be reused
	li	$s3, 0				#s3:i=0
collect_baskets_loopstatement1:
	lw 	$t0, 20($s1)			#t0=spot->num_children
	bge	$s3, $t0, collect_baskets_if	#branch if the first statment is not satisfied
collect_baskets_loopstatement2:
	lw	$t0, 0($s2)			#t0=baskets->num_found
	bge	$t0, $s0, collect_baskets_if	#branch if the second statment is not satisfied
	move	$a0, $s0
	move	$a2, $s2
	#sll	$t0, $s3, 2			#t0=i*4
	mul	$t0, $s3, 4
	#mflo	$t0
	add	$t0, $t0, 24			#t0=24+i*4
	add	$t0, $t0, $s1			#t0=&spot->children[i]
	lw	$a1, 0($t0)			#a1=spot->children[i]
	jal	collect_baskets
	add	$s3, $s3, 1			#i++
	j	collect_baskets_loopstatement1
collect_baskets_if:
	lw	$t0, 0($s2)			#t0=baskets->num_found
	bge	$t0, $s0, collect_baskets_end	#branch if the first statment is not satisfied
	move	$a0, $s1			
	jal	get_num_carrots
	ble	$v0, 0, collect_baskets_end	#branch if the second statment is not satisfied
	lw	$t0, 0($s2)			#t0=baskets->num_found
	#sll	$t0, $t0, 2			#t0=baskets->num_found*4
	mul	$t0, $t0, 4
	add	$t0, $t0, 4			#t0=baskets->num_found*4+4
	add	$t0, $s2, $t0			#t0=&baskets->basket[baskets->num_found]
	sw	$s1, 0($t0)			#baskets->basket[baskets->num_found] = spot;
	lw	$t0, 0($s2)			#t0=baskets->num_found
	add	$t0, $t0, 1			#t0=baskets->num_found+1
	sw	$t0, 0($s2)			#baskets->num_found++;
collect_baskets_end:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20	
	jr  	$ra
