# A while Loop
# Changsong Li
	.data
space:	.asciiz  " "				# space to insert between numbers
	.align 4				# align data segment after each string
	
# end of data segment

# ========================================================================================

# begin text segment

	.text
MAIN:  	addi  $s0,  $zero,  0			# initial $s0 = 0
	addi  $s1,  $zero,  0			# initial $s1 = 0
LOOP:	slti  $t1,  $s0,    10			# $s0 < 10
	beq   $t1,  $zero,  END			# go to END when done
	add   $s1,  $s1,    $s0 		# $s1 = $s1 + $s0
	add   $a0,  $zero,  $s1			# put $s1 in $a0 to print
	add   $v0,  $zero,  1			# set up for int print
	syscall					# print int
	la    $s2,  space			# load address of space for use
	lw    $s2,  0($s2)			# load value of space into register
	add   $a0,  $zero,  $s2			# put space into $a0
	add   $v0,  $zero,  11			# set up for char print
	syscall					# print space
	addi  $s0,  $s0,    1			# $s0++
	j     LOOP				# loop
END:	