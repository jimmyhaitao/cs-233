.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

SEARCH_BUNNIES          = 0xffff0054
CATCH_BUNNY             = 0xffff0058
PUT_BUNNIES_IN_PLAYPEN  = 0xffff005c

PLAYPEN_LOCATION        = 0xffff0044

# interrupt constants
BUNNY_MOVE_INT_MASK     = 0x400
BUNNY_MOVE_ACK          = 0xffff0020

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

.data
# put your data things here
##	read playpen location
##	while(1){
##	update bunnies_info;
##	int bot_x;
##	int bot_y;
## 
##	int bunnies_x = bunnies_info.bunnies[0]/x;
##	int bunnies_y = bunnies info.bunnies[0]/y;
## 	while(bot_x!=bunnies_x||bot_y!=bunnies_y){
##		n++
##		if(bot_x<bunnies_x){
##			update bunnies info and bunnies_x y if out of bound
##			set_angle = 0;
##			set velocity = 10;
##			int bot_x;
##			int bot_y;
##		}
## 		if(bot_x>bunnies_x){
##			update bunnies info and bunnies_x y if out of bound
## 			set_angle = 180;
##			set velocity = 10
##			int bot_x;
##			int bot_y;
##		if(bunnies_y>bot_y){
##			update bunnies info and bunnies_x y if out of bound
##			set_angle = 90;
##			velocity = 10;
##			int bot_x;
##			int bot_y;
##		}
##		if(bunnies_y<bot_y){
##			update bunnies info and bunnies_x y if out of bound
##			set_angle =270;
##			set velocity = 10;
##			int bot_x;
##			int bot_y;
##		}
##		catch_bunny();
##		if(n>5){
##			n-0;
##			move to playpan;
##			put punnies in playpen
##		}
##}

.align 2
bunnies_data: .space 484

##struct BunniesInfo {
##	int num_bunnies; // number of bunnies on map
##	Bunny info[30]; // array of Bunny structs containing info about each bunny
##};

##struct Bunny {
##    int x;  // x location of bunny, in range [5, 295]
##    int y;  // y location of bunny, in range [5, 295]
##    int weight; // weight in Zentners, in range [5, 20]
##    int remaining_cycles;   // cycles remaning before bunny hops, in range [0, 1000000]
##};


.text
main:
	lw	$t6, PLAYPEN_LOCATION	#location
	and	$t7, $t6, 0xffff0000 #t7:x get high bits
	srl	$t7, $t7, 16
	sll	$t6, $t6, 16		#t6:y get lower bits
	srl	$t6, $t6, 16
	li	$t9, 0
main_2:
	# put your code here :)
	
	la	$t0, bunnies_data	#
	sw	$t0, SEARCH_BUNNIES
	
	lw	$t1, BOT_X		#t1=BOT_X
	lw	$t2, BOT_Y		#t2=BOT_Y
	add	$t3, $t0, 4		#s3 ptr points to info	
	lw	$s4, 4($t3)		#s4=b_y
	lw	$s3, 0($t3)		#s3=b_x
	j	loop_x
not1:
	li	$t9, 0
	move $s3, $t7
	move $s4, $t6
loop_x:
	bne	$s3, $t1, move_x_left	#while(b_x!=BOT_X)
loop_y:
	bne	$s4, $t2, move_y_left	#while(b_y!=BOT_Y)
	j	end
move_x_left:
	blt	$t1, $s3, move_x_right
	blt	$t1, 5, main_2
	li	$t5, 180		#t5=180
	sw	$t5, ANGLE		#set angle to 180
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t1, BOT_X		#update BOT_X
	j	move_y_left
move_x_right:
	bgt	$t1, 294, main_2
	li	$t5, 0			#t5=0
	sw	$t5, ANGLE		#set angle to 0
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t1, BOT_X		#update BOT_X
	#j	loop_x
move_y_left:
	beq	$s4, $t2, loop_x
	blt	$s4, $t2, move_y_right
	bgt	$t2, 294, main_2
	li	$t5, 90			#t5=90
	sw	$t5, ANGLE		#set angle to 90
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t2, BOT_Y		#update BOT_Y
	j	loop_x
move_y_right:
	beq	$s4, $t2, loop_x
	blt	$t2, 5, main_2	
	li	$t5, 270		#t5=270
	sw	$t5, ANGLE		#set angle to 270
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t2, BOT_Y		#update BOT_Y
	j	loop_x
	
	# note that we infinite loop to avoid stopping the simulation early
end:
	#bne	$s3, $t1, loop_y
	#bne	$s4, $t2, loop_x
	#li	$t5, 0
	#sw	$t5, VELOCITY
	sw	$t5, CATCH_BUNNY
	#la	$t0, bunnies_data	#
	#sw	$t0, SEARCH_BUNNIES
	#add	$t3, $t0, 4		#s3 ptr points to info	
	#lw	$s1, 4($t3)		#s4=b_y
	#lw	$s2, 0($t3)		#s3=b_x
	#beq $s3, $s2, main_2
	#beq $s4, $s1, main_2
	add	$t9, $t9, 1
	bge $t9, 5, not1
	li	$t8, 3
	#li	$t5, 0
	#sw	$t5, VELOCITY
	sw	$t8, PUT_BUNNIES_IN_PLAYPEN
	j	main_2

############################interupt###################################
.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 12	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     
	sw	$v0, 8($k0)		
	
	
	
	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                
	and	$a0, $a0, 0xf		# ExcCode field                            
	bne	$a0, 0, non_intrpt         

interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, BONK_INT_MASK	# is there a bonk interrupt?                
	bne	$a0, 0, bonk_interrupt   

	and	$a0, $k0, TIMER_INT_MASK	# is there a timer interrupt?
	bne	$a0, 0, timer_interrupt
	
	# add dispatch for other interrupt types here.
	and	$a0, $k0, BUNNY_MOVE_INT_MASK 	# is there a bunny move interrupt?
	bne	$a0, 0, bunny_move_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

bunny_move_interrupt:
	sw      $a1,  BUNNY_MOVE_ACK   # acknowledge interrupt
	
	#do things here
	bne	$s3, $t7, move_bunny
	bne $s4, $t6, move_bunny
	j	 interrupt_dispatch
move_bunny:
	sw	$t0, SEARCH_BUNNIES
	add	$s3, $t0, 4		#s3 ptr points to info	
	lw	$s4, 4($s3)		#s4=b_y
	lw	$s3, 0($s3)		#s3=b_x
	li	$t9, 1
	j       interrupt_dispatch       # see if other interrupts are waiting
bonk_interrupt:
      sw      $a1, 0xffff0060($zero)   # acknowledge interrupt

      li      $a1, 10                  #  ??
      lw      $a0, 0xffff001c($zero)   # what
      and     $a0, $a0, 1              # does
      bne     $a0, $zero, bonk_skip    # this 
      li      $a1, -10                 # code
bonk_skip:                             #  do 
      sw      $a1, VELOCITY   #  ??  

      j       interrupt_dispatch       # see if other interrupts are waiting
      
timer_interrupt:
	sw	$a1, TIMER_ACK		# acknowledge interrupt

	li	$t0, 90			# ???
	sw	$t0, ANGLE		# ???
	sw	$zero, ANGLE_CONTROL	# ???

	lw	$v0, TIMER		# current time
	add	$v0, $v0, 50000  
	sw	$v0, TIMER		# request timer in 50000 cycles

	j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
	li	$v0, PRINT_STRING
	la	$a0, non_intrpt_str
	syscall				# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
	lw	$v0, 8($k0)
	
.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret

