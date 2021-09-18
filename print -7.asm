	.data
num:	.word	12			# reserve space for a number and initialize it to 100
space:	.asciiz " "			# space to insert between numbers
	.align	4			# align data segment after each string
	
# end of data segment

# begin text segment

	.text				# instructions start here
MAIN:	la   $s0,  num			# load address of num for use
	lw   $s0,  0($s0)		# load value of num into register
	la   $s1,  space		# load the address of string space
	lw   $s1,  0($s1)		# load value of space into register
	addi $t0,  $zero,  0		# set $t0 to 0
	addi $t2,  $zero,  100		# set $t2 to 100
LOOP:	slt  $t1,  $t0,   $s0		# $t0 < num
	beq  $t1,  $zero, END		# go to end when done
	add  $a0,  $zero, $t2		# put $t1 in $a0 to print
	add  $v0,  $zero, 1		# set up for int print
	syscall				# print int
	add  $a0,  $zero, $s1		# put space in $a0
	add  $v0,  $zero, 11		# set up for print char
	syscall				# print space
	addi $t2,  $t2,   -7		# decrese the $t1 by 7
	addi $t0,  $t0,   1		# $t0++
	j    LOOP
END:	addi $v0,  $zero, 10		# system call for exit
	syscall				# clean termination of program	