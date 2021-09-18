# Change a decimal number to a 4 bytes binary number
# Changsong Li

	.data
arr:	.space	124				# create a int arr with size 32
	.align	2				# align data segment after each int
	
# end of data segment

#======================================================================================

# begin text segment

	.text					# instrutction starts from here
MAIN:	la	$s0,	arr			# load the address of the arr to $s0
	addi	$s1,	$zero,	0		# assign i = 0
	addi	$s2,	$zero,	1		# assign num = 1
FOR:	slti	$t0,	$s1,	31		# check i < 31
	beq	$t0,	$zero,	ENDFOR		# to the end if it is true
	sll	$t0,	$s1,	2		# $t0 = i * 4
	add	$t0,	$s0,	$t0		# addr. A[i]
	sw	$s2,	0($t0)			# A[i] = num
	sll	$s2,	$s2,	1		# num = num * 2
	addi	$s1,	$s1,	1		# i++		
	j	FOR
ENDFOR:	addi	$v0,	$zero,	5		# set up to read the decimal number from the user
	syscall					# read the decimal number
	move	$s3,	$v0			# put the input to $s3 (input)
	addi	$s1,	$zero,	30		# assign i = 30
	addi	$t0,	$zero,	0		# $t0 = 0
	add	$a0,	$zero,	$t0		# put 0 to $a0 for printing
	addi	$v0,	$zero,	1		# set up the type of printing
	syscall					# printing 0
FOR_OP:	slti	$t0,	$s1,	0		# check i < 0
	bne	$t0,	$zero	END		# stop when it's done
	sll	$t0,	$s1,	2		# $t0 = i * 4
	add	$t0,	$s0,	$t0		# addr. A[i]
	lw	$s2,	0($t0)			# num = A[i]
	slt	$t0,	$s3	$s2		# check input < num
	bne	$t0,	$zero	ELSE		# if input < num, go ELSE
	sub	$s3,	$s3	$s2		# input = input - num
	addi	$t0,	$zero,	1		# $t0 = 1
	add	$a0,	$zero,	$t0		# put 1 to $a0 for printing
	addi	$v0,	$zero,	1		# set up the type of printing
	syscall					# printing 1
	addi	$s1,	$s1,	-1		# i--
	j	FOR_OP				# junp to loop
ELSE:	addi	$t0,	$zero,	0		# $t0 = 0
	add	$a0,	$zero,	$t0		# put 0 to $a0 for printing
	addi	$v0,	$zero,	1		# set up the type of printing
	syscall					# printing 0
	addi	$s1,	$s1,	-1		# i--
	j	FOR_OP				# junp to loop
END:
