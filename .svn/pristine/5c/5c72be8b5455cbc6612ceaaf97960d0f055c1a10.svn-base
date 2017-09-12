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

.data
# put your data things here



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
	# put your code here :)
	la	$t0, bunnies_data	#
	sw	$t0, SEARCH_BUNNIES
	
	lw	$t1, BOT_X		#t1=BOT_X
	lw	$t2, BOT_Y		#t2=BOT_Y
	add	$t3, $t0, 4		#t3 ptr points to info	
	lw	$t4, 4($t3)		#t4=b_y
	lw	$t3, 0($t3)		#t3=b_x
loop_x:
	beq	$t3, $t1, loop_y	#while(b_x!=BOT_X)
	blt	$t1, $t3, else_x
	li	$t5, 180		#t5=180
	sw	$t5, ANGLE		#set angle to 180
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t1, BOT_X		#update BOT_X
	j	loop_x
else_x:
	li	$t5, 0			#t5=0
	sw	$t5, ANGLE		#set angle to 0
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t1, BOT_X		#update BOT_X
	j	loop_x
	
loop_y:
	beq	$t4, $t2, end		#while(b_y!=BOT_Y)
	blt	$t4, $t2, else_y
	li	$t5, 90			#t5=90
	sw	$t5, ANGLE		#set angle to 90
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t2, BOT_Y		#update BOT_Y
	j	loop_y
else_y:	
	li	$t5, 270		#t5=270
	sw	$t5, ANGLE		#set angle to 270
	li	$t5, 1			#t5=1
	sw	$t5, ANGLE_CONTROL	#set angle control to absolute
	li	$t5, 10			#t5=10
	sw	$t5, VELOCITY		#set velocity to 10
	lw	$t2, BOT_Y		#update BOT_Y
	j	loop_y
	
	# note that we infinite loop to avoid stopping the simulation early
end:
	sw	$t5, CATCH_BUNNY
	j	main


