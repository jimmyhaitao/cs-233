# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
PRINT_STRING = 4

.data
null_str: .asciiz "(null) "
.align 2
test0:	.word	p0xb3dc50	p0xb3dc80	p0xb3dcb0	p0xb3dce0	56
p0xb3dc50:	.word	0	0	0	0	73
p0xb3dc80:	.word	0	0	0	0	30
p0xb3dcb0:	.word	0	0	0	0	64
p0xb3dce0:	.word	0	0	0	0	19
.align 2
test1:	.word	p0xb3dd40	p0xb3de30	p0xb3df20	p0xb3e010	17
p0xb3dd40:	.word	p0xb3dd70	p0xb3dda0	p0xb3ddd0	p0xb3de00	26
p0xb3dd70:	.word	0	0	0	0	80
p0xb3dda0:	.word	0	0	0	0	72
p0xb3ddd0:	.word	0	0	0	0	56
p0xb3de00:	.word	0	0	0	0	75
p0xb3de30:	.word	p0xb3de60	p0xb3de90	p0xb3dec0	p0xb3def0	30
p0xb3de60:	.word	0	0	0	0	31
p0xb3de90:	.word	0	0	0	0	16
p0xb3dec0:	.word	0	0	0	0	12
p0xb3def0:	.word	0	0	0	0	50
p0xb3df20:	.word	p0xb3df50	p0xb3df80	p0xb3dfb0	p0xb3dfe0	9
p0xb3df50:	.word	0	0	0	0	98
p0xb3df80:	.word	0	0	0	0	10
p0xb3dfb0:	.word	0	0	0	0	16
p0xb3dfe0:	.word	0	0	0	0	86
p0xb3e010:	.word	p0xb3e040	p0xb3e070	p0xb3e0a0	p0xb3e0d0	77
p0xb3e040:	.word	0	0	0	0	59
p0xb3e070:	.word	0	0	0	0	79
p0xb3e0a0:	.word	0	0	0	0	49
p0xb3e0d0:	.word	0	0	0	0	63


.text
# print int and space ##################################################
#
# argument $a0: number to print
# returns       nothing

print_int_and_space:
    li      $v0, PRINT_INT  # load the syscall option for printing ints
    syscall         # print the number

    li      $a0, ' '        # print a blank space
    li      $v0, PRINT_CHAR # load the syscall option for printing chars
    syscall         # print the char
    
    jr      $ra     # return to the calling procedure

# print string ########################################################
#
# argument $a0: string to print
# returns       nothing

print_string:
    li      $v0, PRINT_STRING   # print string command
    syscall                 # string is in $a0
    jr      $ra

# print string and space ###############################################
#
# argument $a0: string to print
# returns       nothing

print_string_and_space:
    li      $v0, PRINT_STRING   # print string command
    syscall                 # string is in $a0
    li      $a0, ' '        # print a blank space
    li      $v0, PRINT_CHAR # load the syscall option for printing chars
    syscall         # print the char
    jr      $ra


# print newline ########################################################
#
# no arguments
# returns       nothing

print_newline:
    li      $a0, '\n'       # print a newline char.
    li      $v0, PRINT_CHAR
    syscall 
    jr      $ra




# main function ########################################################
#
#  this will test 'find_maximum_node'
#
#########################################################################
.globl main
main:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # save $ra on stack

    la      $a0, test0
    jal     find_maximum_node
    lw      $a0, 16($v0)
    jal     print_int_and_space
    jal     print_newline
    la      $a0, test1
    jal     find_maximum_node
    lw      $a0, 16($v0)
    jal     print_int_and_space
    jal     print_newline

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra