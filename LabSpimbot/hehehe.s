# syscall constants
PRINT_STRING = 4
PRINT_CHAR   = 11
PRINT_INT    = 1

# debug constants
PRINT_INT_ADDR   = 0xffff0080
PRINT_FLOAT_ADDR = 0xffff0084
PRINT_HEX_ADDR   = 0xffff0088

# spimbot constants
VELOCITY       = 0xffff0010
ANGLE          = 0xffff0014
ANGLE_CONTROL  = 0xffff0018
BOT_X          = 0xffff0020
BOT_Y          = 0xffff0024
OTHER_BOT_X    = 0xffff00a0
OTHER_BOT_Y    = 0xffff00a4
TIMER          = 0xffff001c
SCORES_REQUEST = 0xffff1018

# introduced in lab10
SEARCH_BUNNIES          = 0xffff0054
CATCH_BUNNY             = 0xffff0058
PUT_BUNNIES_IN_PLAYPEN  = 0xffff005c
PLAYPEN_LOCATION        = 0xffff0044

# introduced in labSpimbot
LOCK_PLAYPEN            = 0xffff0048
UNLOCK_PLAYPEN          = 0xffff004c
REQUEST_PUZZLE          = 0xffff00d0
SUBMIT_SOLUTION         = 0xffff00d4
NUM_BUNNIES_CARRIED     = 0xffff0050
NUM_CARROTS             = 0xffff0040
PLAYPEN_OTHER_LOCATION  = 0xffff00dc

# interrupt constants
BONK_MASK               = 0x1000
BONK_ACK                = 0xffff0060
TIMER_MASK              = 0x8000
TIMER_ACK               = 0xffff006c
BUNNY_MOVE_INT_MASK     = 0x400
BUNNY_MOVE_ACK          = 0xffff0020
PLAYPEN_UNLOCK_INT_MASK = 0x2000
PLAYPEN_UNLOCK_ACK      = 0xffff005c
EX_CARRY_LIMIT_INT_MASK = 0x4000
EX_CARRY_LIMIT_ACK      = 0xffff002c
REQUEST_PUZZLE_INT_MASK = 0x800
REQUEST_PUZZLE_ACK      = 0xffff00d8

#struct BunniesInfo {
#   int num_bunnies; // number of bunnies on map
#    Bunny info[30];  // array of Bunny structs containing info about each bunny
#};

#struct Bunny {
#    int x;  // x location of bunny, in range [5, 295]
#    int y;  // y location of bunny, in range [5, 295]
#    int weight; // weight in Zentners, in range [5, 20]
#    int remaining_cycles;   // cycles remaning before bunny hops, in range [0, 1000000]
#};

.data
# data things go here
.align 2
bunnies_data: .space 484
.text
#############################################main########################################################
main:
    # go wild
    # the world is your oyster :)
    # put your code here :)
	la		$t0, bunnies_data	#
	sw		$t0, SEARCH_BUNNIES
	
	lw		$t1, BOT_X		#t1=BOT_X
	lw		$t2, BOT_Y		#t2=BOT_Y
	
	jal		find_nearest_bunny
	move	$t3, $v0
	mul		$t3, $t3, 16
	add		$t3, $t0, $t3
	add		$t3, $t3, 4
	lw		$t4, 4($t3)		#t4=b_y
	lw		$t3, 0($t3)		#t3=b_x
loop_x:
	beq		$t3, $t1, loop_y	#while(b_x!=BOT_X)
	blt		$t1, $t3, else_x
	li		$t5, 180		#t5=180
	sw		$t5, ANGLE		#set angle to 180
	li		$t5, 1			#t5=1
	sw		$t5, ANGLE_CONTROL	#set angle control to absolute
	li		$t5, 10			#t5=10
	sw		$t5, VELOCITY		#set velocity to 10
	lw		$t1, BOT_X		#update BOT_X
	j		loop_x
else_x:
	li		$t5, 0			#t5=0
	sw		$t5, ANGLE		#set angle to 0
	li		$t5, 1			#t5=1
	sw		$t5, ANGLE_CONTROL	#set angle control to absolute
	li		$t5, 10			#t5=10
	sw		$t5, VELOCITY		#set velocity to 10
	lw		$t1, BOT_X		#update BOT_X
	j		loop_x
	
loop_y:
	beq		$t4, $t2, end		#while(b_y!=BOT_Y)
	blt		$t4, $t2, else_y
	li		$t5, 90			#t5=90
	sw		$t5, ANGLE		#set angle to 90
	li		$t5, 1			#t5=1
	sw		$t5, ANGLE_CONTROL	#set angle control to absolute
	li		$t5, 10			#t5=10
	sw		$t5, VELOCITY		#set velocity to 10
	lw		$t2, BOT_Y		#update BOT_Y
	j		loop_y
else_y:	
	li		$t5, 270		#t5=270
	sw		$t5, ANGLE		#set angle to 270
	li		$t5, 1			#t5=1
	sw		$t5, ANGLE_CONTROL	#set angle control to absolute
	li		$t5, 10			#t5=10
	sw		$t5, VELOCITY		#set velocity to 10
	lw		$t2, BOT_Y		#update BOT_Y
	j		loop_y
	
	# note that we infinite loop to avoid stopping the simulation early
end:
	sw		$t5, CATCH_BUNNY
	j		main
	
	
	
####################################put bunny back to playpen start######################################
put_bunny_to_playpen:		
		sub		$sp, $sp, 32
		sw		$ra, 0($sp)	
		sw		$t0, 4($sp)	
		sw		$t1, 8($sp)	
		sw		$s3, 12($sp)
		sw		$s4, 16($sp)	
		sw		$t2, 20($sp)
		sw		$t5, 24($sp)
		sw		$t8, 28($sp)				
		lw	$t0, PLAYPEN_LOCATION	#location
		and	$t1, $t0, 0xffff0000 #t1:x get high bits
		srl	$t1, $t1, 16
		sll	$t0, $t0, 16		#t0:y get lower bits
		srl	$t0, $t0, 16
		move $s3, $t1
		move $s4, $t0
		lw	$t1, BOT_X		#t1=BOT_X
		lw	$t2, BOT_Y		#t2=BOT_Y
loop_x:
	bne	$s3, $t1, move_x_left	#while(b_x!=BOT_X)
loop_y:
	bne	$s4, $t2, move_y_left	#while(b_y!=BOT_Y)
	j	put_bunny_to_playpen_end
move_x_left:
	blt	$t1, $s3, move_x_right
	blt	$t1, 5, put_bunny_to_playpen
	li	$t5, 180		#t5=180
	sw	$t5, ANGLE		#set angle to 180
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t1, BOT_X		#update BOT_X
	j	move_y_left
move_x_right:
	bgt	$t1, 294, put_bunny_to_playpen
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
	blt	$t2, 5, put_bunny_to_playpen
	li	$t5, 270		#t5=270
	sw	$t5, ANGLE		#set angle to 270
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t2, BOT_Y		#update BOT_Y
	j	loop_x
	
	# note that we infinite loop to avoid stopping the simulation early

put_bunny_to_playpen_end:
		sw		$t8, PUT_BUNNIES_IN_PLAYPEN
		sw		$t8, LOCK_PLAYPEN
		lw		$ra, 0($sp)	
		lw		$t0, 4($sp)	
		lw		$t1, 8($sp)	
		lw		$s3, 12($sp)
		lw		$s4, 16($sp)	
		lw		$t2, 20($sp)
		lw		$t5, 24($sp)
		lw		$t8, 28($sp)
		add		$sp, $sp, 32
    	jr		$ra	
####################################put bunny back to playpen end##########################################
####################################find_nearest_bunny function start######################################
find_nearest_bunny:
		sub		$sp, $sp, 60
		sw		$ra, 0($sp)	
		sw		$t0, 4($sp)
		sw		$t1, 8($sp)
		sw		$t2, 12($sp)
		sw		$t3, 16($sp)
		sw		$t4, 20($sp)
		sw		$t5, 24($sp)
		sw		$t6, 28($sp)
		sw		$s0, 32($sp)
		sw		$s1, 36($sp)
		sw		$s2, 40($sp)
		sw		$s3, 44($sp)
		sw		$s4, 48($sp)
		sw		$s5, 52($sp)
		sw		$s6, 56($sp)
# note that we infinite loop to avoid stopping the simulation early
		la		$t0, bunnies_data
		sw		$t0, SEARCH_BUNNIES

		sw		$0, VELOCITY             # set the velcoty to be 0
# store the x position of the bunny at the t1
		lw		$t1, 0($t0)              # t1 = num_bunnies
		lw		$t2, BOT_X               # t2 = bot_x
		lw		$t3, BOT_Y               # t3 = bot_y

		lw		$t4, 4($t0)              # t4 = first x position
		lw		$t5, 8($t0)              # t5 = first y position

		move	$s0, $t4               # s0 = current best x
		move	$s1, $t5               # s1 = current best y


		sub		$t4, $t4, $t2           # t4 = first x position - bot x
		sub		$t5, $t5, $t3           # t5 = first y position - bot y
		mul		$t4, $t4, $t4           # t4 = diff_x^2
		mul		$t5, $t5, $t5           # t5 = diff_y^2
		add		$t4, $t4, $t5           # current_best: t4 = distance square

		add		$t6, $t0, 20             # t6 = first address of x
		li		$t5, 1                   # t5 = 1
		move	$s6, $t5				#s6 current best rabbit index
find_nearest_bunny_loop:
		bge 	$t5,$t1, find_nearest_bunny_end_find       # while i<num_bunnies
    	lw 		$s2, 0($t6)              # s2 the next bunny x position
    	lw 		$s3, 4($t6)              # s3 the next bunny y position

		move 	$s4, $s2               # current bunny_x
		move 	$s5, $s3               # current bunny_y
	
		sub 	$s2, $s2, $t2           # s2  x_diff
		mul 	$s2, $s2, $s2           # s2 = x_diff^2
		sub 	$s3, $s3, $t3           # s3 = y_diff
		mul 	$s3, $s3, $s3           # s3 = y_diff^2
		add 	$s2, $s2, $s3           # s2 = total distance square
		bge 	$s2, $t4, find_nearest_bunny_end_update

		move 	$t4, $s2               # update the best distance
		move 	$s0, $s4               # update the best bunny x
		move	$s1, $s5               # update the best bunny y
		move	$s6, $t5
find_nearest_bunny_end_update:
    	add		$t6, $t6, 16
    	add		$t5, $t5, 1
		j		find_nearest_bunny_loop

find_nearest_bunny_end_find:
		move	$v0, $s6
		lw		$ra, 0($sp)	
		lw		$t0, 4($sp)
		lw		$t1, 8($sp)
		lw		$t2, 12($sp)
		lw		$t3, 16($sp)
		lw		$t4, 20($sp)
		lw		$t5, 24($sp)
		lw		$t6, 28($sp)
		lw		$s0, 32($sp)
		lw		$s1, 36($sp)
		lw		$s2, 40($sp)
		lw		$s3, 44($sp)
		lw		$s4, 48($sp)
		lw		$s5, 52($sp)
		lw		$s6, 56($sp)
    	add		$sp, $sp, 60
    	jr		$ra
####################################find_nearest_bunny function end######################################

##########################################interrupt start################################################

# interrupt constants
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

	and	$a0, $k0, BONK_MASK	# is there a bonk interrupt?                
	bne	$a0, 0, bonk_interrupt   

	and	$a0, $k0, TIMER_MASK	# is there a timer interrupt?
	bne	$a0, 0, timer_interrupt
	
	# add dispatch for other interrupt types here.
	and	$a0, $k0, BUNNY_MOVE_INT_MASK 	# is there a bunny move interrupt?
	bne	$a0, 0, bunny_move_interrupt
	
	and	$a0, $k0, PLAYPEN_UNLOCK_INT_MASK 	# is there playpen_unlock_interrupt?
	bne	$a0, 0, playpen_unlock_interrupt
	
#	and	$a0, $k0, EX_CARRY_LIMIT_INT_MASK	# is there ex_carry_limit_interrupt
#	bne	$a0, 0, ex_carry_limit_interrupt
	
#	and	$a0, $k0, REQUEST_PUZZLE_INT_MASK	# is there a bunny move interrupt?
#	bne	$a0, 0, request_puzzle_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

playpen_unlock_interrupt:
	sw      $a1,  PLAYPEN_UNLOCK_ACK
	jal		put_bunny_to_playpen
	
	j       interrupt_dispatch

	
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
####################################################interrupt end############################################
