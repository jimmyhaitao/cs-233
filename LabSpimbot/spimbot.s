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
PLAYPEN_UNLOCK_ACK      = 0xffff0028
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


.globl turns
turns: .word 1 0 -1 0

.data
# data things go here
	weight:	.word 0
	bunny_move_flag: .word 0
	puzzle_ready_flag: .word 0
.align 2
bunnies_data: .space 484
puzzle_data: .space 9804
basket_data: .space 44
puzzle_solution: .space 4



#puzzle_ready: .word 0


.text
#############################################main########################################################
main:
    # go wild
    # the world is your oyster :)
    # put your code here :)
    li	 	$t4, 			BUNNY_MOVE_INT_MASK		# bunny interrupt enable bit
	or 	 	$t4,	$t4,	BONK_MASK               
	or 	 	$t4,	$t4,	PLAYPEN_UNLOCK_INT_MASK # playpen unlock bit
	or 		$t4, 	$t4,	REQUEST_PUZZLE_INT_MASK # puzzle request bit
	or		$t4, 	$t4,	1						# global interrupt enable
	mtc0	$t4, 	$12								# set interrupt mask (Status register)
	la	$t9, puzzle_data
	sw	$t9, REQUEST_PUZZLE
start:
	la	$t6, bunny_move_flag	
	sw	$0, 0($t6)			#reset bunny_move_flag
	la	$t0, bunnies_data	#
	sw	$t0, SEARCH_BUNNIES

	lw	$t1, BOT_X	#t1=BOT_X
	lw	$t2, BOT_Y	#t2=BOT_Y

	jal	find_nearest_bunny
	move	$t3, $v0
	mul	$t3, $t3, 16
	add	$t3, $t0, $t3
	add	$t3, $t3, 4
	lw	$t4, 4($t3)	#t4=b_y
	lw	$t6, 8($t3) #t6=weight
	lw	$t3, 0($t3)	#t3=b_x
	la	$t7, weight
	lw	$t8, 0($t7)		#total weight
	add $t8, $t8, $t6
	bge $t8, 100, put_bunny_to_playpen
	
loop_x:
	beq	$t3, $t1, loop_y	#while(b_x!=BOT_X)
	blt	$t1, $t3, else_x
	li	$t5, 180	#t5=180
	sw	$t5, ANGLE	#set angle to 180
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t1, BOT_X	#update BOT_X
	j	loop_x
else_x:
	li	$t5, 0	#t5=0
	sw	$t5, ANGLE	#set angle to 0
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t1, BOT_X	#update BOT_X
	j	loop_x

loop_y:
	beq	$t4, $t2, end	#while(b_y!=BOT_Y)
	blt	$t4, $t2, else_y
	li	$t5, 90	#t5=90
	sw	$t5, ANGLE	#set angle to 90
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t2, BOT_Y	#update BOT_Y
	j	loop_y
else_y:
	li	$t5, 270	#t5=270
	sw	$t5, ANGLE	#set angle to 270
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t2, BOT_Y	#update BOT_Y
	j	loop_y

	# note that we infinite loop to avoid stopping the simulation early
end:
	la	$t6, bunny_move_flag
	lw	$t6, 0($t6)
	bne	$t6, 0, start
	sw	$t5, CATCH_BUNNY
	sw	$t8, 0($t7)	#update total weight
	la  $s0, puzzle_ready_flag
	lw  $s0, 0($s0)
	bne $0 , $s0, solve_puzzle
	j	start


solve_puzzle:
	sw	$0, VELOCITY
	jal	search_carrot
	la  $s0, puzzle_ready_flag
	sw  $0, 0($s0)
	la	$t9, puzzle_data
	sw	$t9, REQUEST_PUZZLE
	j start
####################################put bunny back to playpen start######################################
put_bunny_to_playpen:
	sub	$sp, $sp, 32
	sw	$ra, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$t2, 20($sp)
	sw	$t5, 24($sp)
	sw	$t8, 28($sp)
	lw	$t0, PLAYPEN_LOCATION	#location
	and	$t1, $t0, 0xffff0000 #t1:x get high bits
	srl	$t1, $t1, 16
	sll	$t0, $t0, 16	#t0:y get lower bits
	srl	$t0, $t0, 16
	move $s3, $t1
	move $s4, $t0
	lw	$t1, BOT_X	#t1=BOT_X
	lw	$t2, BOT_Y	#t2=BOT_Y
loop_x2:
	bne	$s3, $t1, move_x_left2	#while(b_x!=BOT_X)
loop_y2:
	bne	$s4, $t2, move_y_left2	#while(b_y!=BOT_Y)
	j	put_bunny_to_playpen_end
move_x_left2:
	blt	$t1, $s3, move_x_right2
	blt	$t1, 5, put_bunny_to_playpen
	li	$t5, 180	#t5=180
	sw	$t5, ANGLE	#set angle to 180
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t1, BOT_X	#update BOT_X
	j	move_y_left2
move_x_right2:
	bgt	$t1, 294, put_bunny_to_playpen
	li	$t5, 0	#t5=0
	sw	$t5, ANGLE	#set angle to 0
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t1, BOT_X	#update BOT_X
	#j	loop_x2
move_y_left2:
	beq	$s4, $t2, loop_x2
	blt	$s4, $t2, move_y_right2
	bgt	$t2, 294, put_bunny_to_playpen
	li	$t5, 90	#t5=90
	sw	$t5, ANGLE	#set angle to 90
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t2, BOT_Y	#update BOT_Y
	j	loop_x2
move_y_right2:
	beq	$s4, $t2, loop_x2
	blt	$t2, 5, put_bunny_to_playpen
	li	$t5, 270	#t5=270
	sw	$t5, ANGLE	#set angle to 270
	li	$t5, 1	#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10	#t5=10
	sw	$t5, VELOCITY	#set velocity to 10
	lw	$t2, BOT_Y	#update BOT_Y
	j	loop_x2

	# note that we infinite loop to avoid stopping the simulation early

put_bunny_to_playpen_end:
	
	la	$t8, NUM_BUNNIES_CARRIED
	lw	$t8, 0($t8)
	sw	$t8, PUT_BUNNIES_IN_PLAYPEN
	sw	$t8, LOCK_PLAYPEN
	lw	$ra, 0($sp)
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$t2, 20($sp)
	lw	$t5, 24($sp)
	lw	$t8, 28($sp)
	add	$sp, $sp, 32
	la	$t7, weight
	sw	$0, 0($t7)
    jr	$ra
####################################put bunny back to playpen end##########################################

####################################find_nearest_bunny function start######################################
find_nearest_bunny:
	sub	$sp, $sp, 60
	sw	$ra, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t3, 16($sp)
	sw	$t4, 20($sp)
	sw	$t5, 24($sp)
	sw	$t6, 28($sp)
	sw	$s0, 32($sp)
	sw	$s1, 36($sp)
	sw	$s2, 40($sp)
	sw	$s3, 44($sp)
	sw	$s4, 48($sp)
	sw	$s5, 52($sp)
	sw	$s6, 56($sp)
# note that we infinite loop to avoid stopping the simulation early
	la	$t0, bunnies_data
	sw	$t0, SEARCH_BUNNIES

	sw	$0, VELOCITY             # set the velcoty to be 0
# store the x position of the bunny at the t1
	lw	$t1, 0($t0)              # t1 = num_bunnies
	lw	$t2, BOT_X               # t2 = bot_x
	lw	$t3, BOT_Y               # t3 = bot_y

	lw	$t4, 4($t0)              # t4 = first x position
	lw	$t5, 8($t0)              # t5 = first y position

	move	$s0, $t4               # s0 = current best x
	move	$s1, $t5               # s1 = current best y


	sub	$t4, $t4, $t2           # t4 = first x position - bot x
	sub	$t5, $t5, $t3           # t5 = first y position - bot y
	mul	$t4, $t4, $t4           # t4 = diff_x^2
	mul	$t5, $t5, $t5           # t5 = diff_y^2
	add	$t4, $t4, $t5           # current_best: t4 = distance square

	add	$t6, $t0, 20             # t6 = first address of x
	li	$t5, 1                   # t5 = 1
	move	$s6, $t5	#s6 current best rabbit index
find_nearest_bunny_loop:
	bge 	$t5,$t1, find_nearest_bunny_end_find       # while i<num_bunnies
    	lw 	$s2, 0($t6)              # s2 the next bunny x position
    	lw 	$s3, 4($t6)              # s3 the next bunny y position

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
    	add	$t6, $t6, 16
    	add	$t5, $t5, 1
	j	find_nearest_bunny_loop

find_nearest_bunny_end_find:
	move	$v0, $s6
	lw	$ra, 0($sp)
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t3, 16($sp)
	lw	$t4, 20($sp)
	lw	$t5, 24($sp)
	lw	$t6, 28($sp)
	lw	$s0, 32($sp)
	lw	$s1, 36($sp)
	lw	$s2, 40($sp)
	lw	$s3, 44($sp)
	lw	$s4, 48($sp)
	lw	$s5, 52($sp)
	lw	$s6, 56($sp)
    add	$sp, $sp, 60
    jr	$ra
####################################find_nearest_bunny function end######################################



##########################################interrupt start################################################

# interrupt constants
.kdata	# interrupt handler data (separated just for readability)
chunkIH:	.space 12	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at	# Save $at
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)	# Get some free registers
	sw	$a1, 4($k0)	# by storing them to a global variable
	sw	$v0, 8($k0)

	mfc0	$k0, $13	# Get Cause register
	srl	$a0, $k0, 2
	and	$a0, $a0, 0xf	# ExcCode field
	bne	$a0, 0, non_intrpt

interrupt_dispatch:	# Interrupt:
	mfc0	$k0, $13	# Get Cause register, again

	beq	$k0, 0, done	# handled all outstanding interrupts

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

	and	$a0, $k0, REQUEST_PUZZLE_INT_MASK	# is there a bunny move interrupt?
	bne	$a0, 0, request_puzzle_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall
	j	done


request_puzzle_interrupt:
  	li $a0, 1
	sw $a0, REQUEST_PUZZLE_ACK	# acknowledge interrupt
	la $a1, puzzle_ready_flag
	sw $a0,0($a1)
	j interrupt_dispatch

playpen_unlock_interrupt:
  li $a0, 1
  sw $a0, PLAYPEN_UNLOCK_ACK	# acknowledge interrupt
  la $a1, my_unlock_flag
  sw $a0, 0($a1)
  j interrupt_dispatch

bunny_move_interrupt:
	sw      $a1,  BUNNY_MOVE_ACK   # acknowledge interrupt
	sub	$sp, $sp, 8
	sw	$t6, 0($sp)
	sw	$t5, 4($sp)
	#do things here
	la	$t5, bunny_move_flag
	li	$t6, 1
	sw	$t6, 0($t5)

	lw	$t6, 0($sp)
	lw	$t5, 4($sp)
	add	$sp, $sp, 8
	j	interrupt_dispatch

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
	sw	$a1, TIMER_ACK	# acknowledge interrupt

	li	$t0, 90	# ???
	sw	$t0, ANGLE	# ???
	sw	$zero, ANGLE_CONTROL	# ???

	lw	$v0, TIMER	# current time
	add	$v0, $v0, 50000
	sw	$v0, TIMER	# request timer in 50000 cycles

	j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:	# was some non-interrupt
	li	$v0, PRINT_STRING
	la	$a0, non_intrpt_str
	syscall	# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)	# Restore saved registers
	lw	$a1, 4($k0)
	lw	$v0, 8($k0)

.set noat
	move	$at, $k1	# Restore $at
.set at
	eret
####################################################interrupt end############################################





####################################search_carrot_start#########################################
.text
.globl search_carrot
search_carrot:
	move	$v0, $0	# set return value to 0 early
	sub $sp, $sp, 16
	sw  $a0, 0($sp)
    sw  $a1, 4($sp)
    sw  $a2, 8($sp)
    sw  $a3, 12($sp)

	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)


	li $a0, 10
	la $a2, puzzle_data
    lw $a1, 9800($a2)
    sw $0, basket_data
    la $a3, basket_data

	beq	$a2, 0, sc_ret	# if (root == NULL), return 0
	beq	$a3, 0, sc_ret	# if (baskets == NULL), return 0

	move	$s0, $a1	# $s0 = int k
	move	$s1, $a3	# $s1 = Baskets *baskets

	sw	$0, 0($a3)	# baskets->num_found = 0

	move	$t0, $0	# $t0 = int i = 0
sc_for:
	bge	$t0, $a0, sc_done	# if (i >= max_baskets), done

	mul	$t1, $t0, 4
	add	$t1, $t1, $a3
	sw	$t0, 4($t1)	# baskets->basket[i] = NULL

	add	$t0, $t0, 1	# i++
	j	sc_for


sc_done:
	move	$a1, $a2
	move	$a2, $a3
	jal	collect_baskets	# collect_baskets(max_baskets, root, baskets)

	move	$a0, $s0
	move	$a1, $s1
	jal	pick_best_k_baskets	# pick_best_k_baskets(k, baskets)

	move	$a0, $s0
	move	$a1, $s1


	jal	get_secret_id	# get_secret_id(k, baskets), tail call

sc_ret:

    sw $v0, puzzle_solution
    la $t0, puzzle_solution
    sw $t0, SUBMIT_SOLUTION

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12

	lw  $a0, 0($sp)
    lw  $a1, 4($sp)
    lw  $a2, 8($sp)
    lw  $a3, 12($sp)
	add $sp, $sp, 16

    la  $t0,puzzle_ready_flag
    sw  $0, 0($t0)
    jr	$ra


.globl pick_best_k_baskets
pick_best_k_baskets:
	bne	$a1, 0, pbkb_do
	jr	$ra

pbkb_do:
	sub	$sp, $sp, 32
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)

	move	$s0, $a0	# $s0 = int k
	move	$s1, $a1	# $s1 = Baskets *baskets

	li	$s2, 0	# $s2 = int i = 0
pbkb_for_i:
	bge	$s2, $s0, pbkb_done	# if (i >= k), done

	lw	$s3, 0($s1)
	sub	$s3, $s3, 1	# $s3 = int j = baskets->num_found - 1
pbkb_for_j:
	ble	$s3, $s2, pbkb_for_j_done	# if (j <= i), done

	sub	$s5, $s3, 1
	mul	$s5, $s5, 4
	add	$s5, $s5, $s1
	lw	$a0, 4($s5)	# baskets->basket[j-1]
	jal	get_num_carrots	# get_num_carrots(baskets->basket[j-1])
	move	$s4, $v0

	mul	$s6, $s3, 4
	add	$s6, $s6, $s1
	lw	$a0, 4($s6)	# baskets->basket[j]
	jal	get_num_carrots	# get_num_carrots(baskets->basket[j])

	bge	$s4, $v0, pbkb_for_j_cont	# if (get_num_carrots(baskets->basket[j-1]) >= get_num_carrots(baskets->basket[j])), skip

	## This is very inefficient in MIPS. Can you think of a better way?

	## We're changing the _values_ of the array elements, so we don't need to
	## recompute addresses every time, and can reuse them from earlier.

	lw	$t0, 4($s6)	# baskets->basket[j]
	lw	$t1, 4($s5)	# baskets->basket[j-1]
	xor	$t2, $t0, $t1	# baskets->basket[j] ^ baskets->basket[j-1]
	sw	$t2, 4($s6)	# baskets->basket[j] = baskets->basket[j] ^ baskets->basket[j-1]

	lw	$t0, 4($s6)	# baskets->basket[j]
	lw	$t1, 4($s5)	# baskets->basket[j-1]
	xor	$t2, $t0, $t1	# baskets->basket[j] ^ baskets->basket[j-1]
	sw	$t2, 4($s5)	# baskets->basket[j-1] = baskets->basket[j] ^ baskets->basket[j-1]

	lw	$t0, 4($s6)	# baskets->basket[j]
	lw	$t1, 4($s5)	# baskets->basket[j-1]
	xor	$t2, $t0, $t1	# baskets->basket[j] ^ baskets->basket[j-1]
	sw	$t2, 4($s6)	# baskets->basket[j] = baskets->basket[j] ^ baskets->basket[j-1]

pbkb_for_j_cont:
	sub	$s3, $s3, 1	# j--
	j	pbkb_for_j

pbkb_for_j_done:
	add	$s2, $s2, 1	# i++
	j	pbkb_for_i

pbkb_done:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	add	$sp, $sp, 32
	jr	$ra


.globl get_secret_id
get_secret_id:
	bne	$a1, 0, gsi_do	# if (baskets != NULL), continue
	move	$v0, $0	# return 0
	jr	$ra

gsi_do:
	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)

	move	$s0, $a0	# $s0 = int k
	move	$s1, $a1	# $s1 = Baskets *baskets
	move	$s2, $0	# $s2 = int secret_id = 0

	move	$s3, $0	# $s3 = int i = 0
gsi_for:
	bge	$s3, $s0, gsi_return	# if (i >= k), done

	mul	$t0, $s3, 4
	add	$t0, $t0, $s1
	lw	$t0, 4($t0)	# baskets->basket[i]

	lw	$a0, 16($t0)	# baskets->basket[i]->identity
	lw	$a1, 12($t0)	# baskets->basket[i]->id_size
	jal	calculate_identity	# calculate_identity(baskets->basket[i]->identity, baskets->basket[i]->id_size)

	addu	$s2, $s2, $v0	# secret_it += ...

	add	$s3, $s3, 1	# i++
	j	gsi_for

gsi_return:
	move	$v0, $s2	# return secret_id

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20
	jr	$ra


.globl get_num_carrots
get_num_carrots:
	bne	$a0, 0, gnc_do	# if (spot != NULL), continue
	move	$v0, $0	# return 0
	jr	$ra

gnc_do:
	lw	$t0, 8($a0)	# spot->dirt
	xor	$t0, $t0, 0x00ff00ff	# $t0 = unsigned int dig = spot->dirt ^ 0x00ff00ff

	and	$t1, $t0, 0xffffff 	# dig & 0xffffff
	sll	$t1, $t1, 8	# (dig & 0xffffff) << 8

	and	$t2, $t0, 0xff000000 	# dig & 0xff00aadi0000
	srl	$t2, $t2, 24	# (dig & 0xff000000) >> 24

	or	$t0, $t1, $t2	# dig = ((dig & 0xffffff) << 8) | ((dig & 0xff000000) >> 24)

	lw	$v0, 4($a0)	# spot->basket
	xor	$v0, $v0, $t0	# return spot->basket ^ dig
	jr	$ra




.globl collect_baskets
collect_baskets:
	beq	$a1, 0, cb_ret	# if (spot == NULL), return
	beq	$a2, 0, cb_ret	# if (baskets == NULL), return
	lb	$t0, 0($a1)
	beq	$t0, 1, cb_ret	# if (spot->seen == 1), return

	li	$t0, 1
	sb	$t0, 0($a1)	# spot->seen = 1

	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)

	move	$s0, $a0	# $s0 = int max_baskets
	move	$s1, $a1	# $s1 = Node *spot
	move	$s2, $a2	# $s2 = Baskets *baskets

	move	$s3, $0	# $s3 = int i = 0
cb_for:
	lw	$t0, 20($s1)	# spot->num_children
	bge	$s3, $t0, cb_done	# if (i >= spot->num_children), done
	lw	$t0, 0($s2)	# baskets->num_found
	bge	$t0, $s0, cb_done	# if (baskets->num_found >= max_baskets), done

	move	$a0, $s0
	mul	$a1, $s3, 4
	add	$a1, $a1, $s1
	lw	$a1, 24($a1)	# spot->children[i]
	move	$a2, $s2
	jal	collect_baskets	# collect_baskets(max_baskets, spot->children[i], baskets)

	add	$s3, $s3, 1	# i++
	j	cb_for


cb_done:
	lw	$t0, 0($s2)	# baskets->num_found
	bge	$t0, $s0, cb_return	# if (baskets->num_found >= max_baskets), return

	move	$a0, $s1
	jal	get_num_carrots
	ble	$v0, 0, cb_return 	# if (get_num_carrots(spot) <= 0), return

	lw	$t0, 0($s2)	# baskets->num_found
	mul	$t1, $t0, 4
	add	$t1, $t1, $s2
	sw	$s1, 4($t1)	# baskets->basket[baskets->num_found] = spot

	add	$t0, $t0, 1
	sw	$t0, 0($s2)	# baskets->num_found++

cb_return:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20

cb_ret:
	jr	$ra


.globl twisted_sum_array
twisted_sum_array:
	li	$v0, 0	# $v0 = int sum = 0

	li	$t0, 0	# $t0 = int i = 0
tsa_for:
	bge	$t0, $a1, tsa_done	# if (i >= length), done

	sub	$t1, $a1, 1	# length - 1
	sub	$t1, $t1, $t0	# length - 1 - i
	mul	$t1, $t1, 4
	add	$t1, $t1, $a0	# &v[length - 1 - i]
	lw	$t2, 0($t1)	# v[length - 1 - i]
	and	$t2, $t2, 1	# v[length - 1 - i] & 1

	beq	$t2, 0, tsa_skip	# if (v[length - 1 - i] & 1 == 0), skip
	sra	$v0, $v0, 1	# sum >>= 1

tsa_skip:
	mul	$t1, $t0, 4
	add	$t1, $t1, $a0	# &v[i]
	lw	$t2, 0($t1)	# v[i]
	addu	$v0, $v0, $t2	# sum += v[i]

	add	$t0, $t0, 1	# i++
	j	tsa_for

tsa_done:
	jr	$ra	# $v0 is already sum


.globl max_conts_bits_in_common
max_conts_bits_in_common:
	li	$t1, 0	# $t1 = int bits_seen = 0
	li	$v0, 0	# $v0 = int max_seen = 0
	and	$t2, $a0, $a1	# $t2 = int c = a & b

	li	$t0, 0	# $t0 = int i = 0
mcbic_for:
	bge	$t0, 32, mcbic_done	# if (i >= INT_SIZE), done

	sra	$t3, $t2, $t0	# c >> i
	and	$t3, $t3, 1	# $t3 = int bit = (c >> i) & 1

	beq	$t3, 0, mcbic_else 	# if (bit == 0), else
	add	$t1, $t1, 1	# bits_seen++
	j	mcbic_cont

mcbic_else:
	ble	$t1, $v0, mcbic_skip 	# if (bit_seen <= max_seen), skip
	move	$v0, $t1	# max_seen = bits_seen

mcbic_skip:
	li	$t1, 0	# bits_seen = 0

mcbic_cont:
	add	$t0, $t0, 1	# i++
	j	mcbic_for

mcbic_done:
	ble	$t1, $v0, mcbic_ret 	# if (bits_seen <= max_seen), skip
	move	$v0, $t1	# max_seen = bits_seen

mcbic_ret:
	jr	$ra	# $v0 is already max_seen



.globl detect_parity
detect_parity:
	li	$t1, 0	# $t1 = int bits_counted = 0
	li	$v0, 1	# $v0 = int return_value = 1

	li	$t0, 0	# $t0 = int i = 0
dp_for:
	bge	$t0, 32, dp_done	# if (i >= INT_SIZE), done

	sra	$t3, $a0, $t0	# number >> i
	and	$t3, $t3, 1	# $t3 = int bit = (number >> i) & 1

	beq	$t3, 0, dp_skip	# if (bit == 0), skip
	add	$t1, $t1, 1	# bits_counted++

dp_skip:
	add	$t0, $t0, 1	# i++
	j	dp_for

dp_done:
	rem	$t3, $t1, 2	# bits_counted % 2
	beq	$t3, 0, dp_ret	# if (bits_counted % 2 == 0), skip
	li	$v0, 0	# return_value = 0

dp_ret:
	jr	$ra	# $v0 is already return_value



.globl calculate_identity
calculate_identity:
	sub	$sp, $sp, 36
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)

	move	$s0, $a0	# $s0 = int *v
	move	$s1, $a1	# $s1 = int size

	move	$s2, $s1	# $s2 = int dist = size
	move	$s3, $0	# $s3 = int total = 0
	li	$s4, -1	# $s4 = int idx = -1

	sw	$s1, turns+4	# turns[1] = size
	mul	$t0, $s1, $s4	# -size
	sw	$t0, turns+12	# turns[3] = -size

ci_while:
	ble	$s2, 0, ci_done	# if (dist <= 0), done

	li	$s5, 0	# $s5 = int i = 0
ci_for_i:
	bge	$s5, 4, ci_while 	# if (i >= 4), done

	li	$s6, 0	# $s6 = int j = 0
ci_for_j:
	bge	$s6, $s2, ci_for_j_done # if (j >= dist), dine

	la	$t1, turns
	mul	$t0, $s5, 4
	add	$t0, $t0, $t1	# &turns[i]
	lw	$t0, 0($t0)	# turns[i]
	add	$s4, $s4, $t0	# idx = idx + turns[i]

	move	$a0, $s3	# total

	mul	$s7, $s4, 4
	add	$s7, $s7, $s0	# &v[idx]
	lw	$a1, 0($s7)	# v[idx]

	jal	accumulate	# accumulate(total, v[idx])
	move	$s3, $v0	# total = accumulate(total, v[idx])
	sw	$s3, 0($s7)	# v[idx] = total

	add	$s6, $s6, 1	# j++
	j	ci_for_j

ci_for_j_done:
	rem	$t0, $s5, 2	# i % 2
	bne	$t0, 0, ci_skip	# if (i % 2 != 0), skip
	sub	$s2, $s2, 1	# dist--

ci_skip:
	add	$s5, $s5, 1	# i++
	j	ci_for_i

ci_done:
	move	$a0, $s0	# v
	mul	$a1, $s1, $s1	# size * size

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	add	$sp, $sp, 36

	# tail call trick
	j	twisted_sum_array	# twisted_sum_array(v, size * size)


.globl accumulate
accumulate:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

	move	$s0, $a0
	move	$s1, $a1

	jal	max_conts_bits_in_common
	blt	$v0, 2, a_dp
	or	$v0, $s0, $s1
	j	a_ret

a_dp:
	move	$a0, $s1
	jal	detect_parity
	bne	$v0, 0, a_mul
	addu	$v0, $s0, $s1
	j	a_ret

a_mul:
	mul	$v0, $s0, $s1

a_ret:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	jr	$ra
