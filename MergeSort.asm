 # This program is an merge sort. It will read a number which is size of the integer array. The size won't be 
# larger than 20. After that, the program will read elements of the array. Then sort the array, and print the each
# elment.
#
# Changsong Li
	
	.data
arr:	.space	80						# apply the memory for the array with size 20
aux:	.space	80						# apply the memory for the array with size 20
size:	.asciiz	"Enter the number of elements in the array: "	# create a null-terminated string.
	.align	2						# align data segment after each string
num:	.asciiz	"Enter the array elements: "			# create a null-terminated string.
	.align 2						# align data segment after each string
sorted:	.asciiz	"The elements sorted in ascending order are: "	# create a null-terminated string.
	.align 2						# align data segment

		
# end of data segment
	
# ========================================================================================================

# begin text segment


	.text
MAIN:	la	$s0,	arr					# arr(s0) load the address of the array
	la	$a0,	size					# load the address of the string size
	addi	$v0,	$zero,	4				# set up printing for prompt
	syscall							# printing the prompt
	addi	$v0,	$zero,	5				# read number of elements from user
	syscall							# read from user
	move	$s1,	$v0					# size = user's input
	la	$a0,	num					# load the string for the prompt
	addi	$v0,	$zero,	4				# prepare for printing
	syscall							# printing
	addi	$s2,	$zero,	0				# i = 0
FOR:	slt	$t0,	$s2,	$s1				# i < size
	beq	$zero,	$t0,	FOREND				# i >= size, stop
	addi	$v0,	$zero,	5				# prepare for reading number of elements from user
	syscall							# read user's input
	sll	$t0,	$s2,	2				# i * 4 for get offset
	add 	$t0,	$s0,	$t0				# get the address of arr[i]
	sw	$v0,	0($t0)					# arr[i] = user input
	addi	$s2,	$s2,	1				# i++
	j	FOR
FOREND:	addi	$a0,	$s0,	0				# pass the argument arr
	addi	$a1,	$s1,	0				# pass the size of the array
	jal	MS
	la	$a0,	sorted					# load the string for sorted
	addi	$v0,	$zero,	4				# prepare for printing
	syscall							# printing
	addi	$s2,	$zero,	0				# i = 0
PFOR:	slt	$t0,	$s2,	$s1				# i < size
	beq	$zero,	$t0,	END				# i >= size, stop
	sll	$t0,	$s2,	2				# i * 4 for get offset
	add 	$t0,	$s0,	$t0				# get the address of arr[i]
	lw	$a0,	0($t0)					# prepare to print arr[i]
	addi	$v0,	$zero,	1				# set up for printing integer
	syscall							# printing integer
	addi	$a0,	$zero,	' '				# prepare to print space
	addi	$v0,	$zero,	11				# set up for printing character
	syscall							# print space
	addi	$s2,	$s2,	1				# i++
	j	PFOR						# jump back
END:	addi	$v0,	$zero,	10				# ready to end the program
	syscall							# exit
	
# end of the text

# =================================================================================================


MS:	addi	$sp,	$sp,	-16				# get the space on the stack
	sw	$a0,	0($sp)					# put the a0 to the stack
	sw	$a1,	4($sp)					# put the a1 to the stack
	sw	$s0,	8($sp)					# put the s0 to the stack
	sw	$ra,	12($sp)					# put the ra to the stack
	la	$s0,	aux					# load the address of aux
	addi	$a3,	$a1,	-1				# put the size - 1 to argument4 
	addi	$a2,	$zero,	0				# put the 0 to argument 3
	addi	$a1,	$s0,	0				# put the aux to argument2 
	jal	MS1						# jump to MergeSort1
	lw	$a0,	0($sp)					# load the a0 from the stack
	lw	$a1,	4($sp)					# load the a1 from the stack
	lw	$s0,	8($sp)					# load the s0 from the stack
	lw	$ra,	12($sp)					# load the ra from the stack
	addi	$sp,	$sp,	12				# shift the stack up
	jr	$ra						# jump back

		
MS1:	slt	$t0,	$a2,	$a3				# if s < e
	beq	$t0,	$zero,	ENDMS1				# not, then stop
	addi	$sp,	$sp,	-20				# get the space on the stack
	sw	$a0,	0($sp)					# put the a0 to the stack
	sw	$a1,	4($sp)					# put the a1 to the stack
	sw	$a2,	8($sp)					# put the a2 to the stack
	sw	$a3,	12($sp)					# put the a3 to the stack
	sw	$ra,	16($sp)					# put the ra to the stack
	add	$t0,	$a2,	$a3				# $t0 = s + e
	srl	$t0,	$t0,	1				# $t0 = (s + e)/2
	addi	$a3,	$t0,	0				# a3 = (s + e)/2
	jal	MS1						# call the method
	addi	$t0,	$a3,	0				# t0 = (s + e) / 2
	lw	$a3,	12($sp)					# a3 = e
	addi	$a2,	$t0,	1				# a2 = (s + e) / 2 + 1
	jal 	MS1						# call the method
	addi	$a3,	$a2,	0				# a3 = (s + e) / 2 + 1
	lw	$a2,	8($sp)					# a2 = s
	lw	$t0,	12($sp)					# t0 = e
	sw	$t0,	-4($sp)					# put fifth variable to bottom of stack
	jal	MERGE						# call the merge method
	lw	$a0,	0($sp)					# load the a0 from the stack
	lw	$a1,	4($sp)					# load the a1 from the stack
	lw	$a2,	8($sp)					# load the a2 from the stack
	lw	$a3,	12($sp)					# load the a3 from the stack
	lw	$ra,	16($sp)					# load the ra from the stack
	addi	$sp,	$sp,	20				# shift the stack up
ENDMS1:	jr	$ra


MERGE:	addi	$sp,	$sp,	-20				# apply memory on stack for s register ra and fifth arg
	sw	$s0,	0($sp)					# put s0 to stack
	sw	$s1,	4($sp)					# put s1 to stack
	sw	$s2,	8($sp)					# put s2 to stack
	sw	$s3,	12($sp)					# put s3 to stack
	lw	$s3,	16($sp)					# load 5th arg from stack
	addi	$s0,	$a2,	0				# i = s1
	addi	$s1,	$a3,	0				# j = s2
	addi	$s2,	$a2,	0				# k = s1
WHILE1:	slt	$t3,	$s0,	$a3				# i < s2
	beq	$t3,	$zero,	WHILE2				# not, then stop
	slt	$t3,	$s3,	$s1				# j <= e2
	bne	$t3,	$zero,	WHILE2				# not, then stop
	sll	$t0,	$s0,	2				# t0 = get offset of i
	add	$t0,	$a0,	$t0				# get address of Y[i]
	lw	$t0,	0($t0)					# t0 = Y[i]
	sll	$t1,	$s1,	2				# t1 = get offset of j
	add	$t1,	$a0,	$t1				# get the address of Y[j]
	lw	$t1,	0($t1)					# t1 = Y[j]
	sll	$t2,	$s2,	2				# get offset of k
	add	$t2,	$a1,	$t2				# get address of A[k]
	slt	$t3,	$t0,	$t1				# Y[i] < Y[j]
	beq	$t3,	$zero,	ELSE				# not, then jump to else
	sw	$t0,	0($t2)					# A[k] =Y[i]
	addi	$s0,	$s0,	1				# i++
	j	INC						# jumpt to increment
ELSE:	sw	$t1,	0($t2)					# A[k] =Y[i]
	addi	$s1,	$s1,	1				# j++
INC:	addi	$s2,	$s2,	1				# k++
	j	WHILE1						# jump back to while1
WHILE2:	slt	$t3,	$s0,	$a3				# check i < s2
	beq	$t3,	$zero,	WHILE3				# not, then jump to while 3
	sll	$t2,	$s2,	2				# get offset of k
	add	$t2,	$a1,	$t2				# get address of A[k]
	sll	$t0,	$s0,	2				# t0 = get offset of i
	add	$t0,	$a0,	$t0				# get address of Y[i]
	lw	$t0,	0($t0)					# t0 = Y[i]
	sw	$t0,	0($t2)					# A[k] =Y[i]
	addi	$s0,	$s0,	1				# i++
	addi	$s2,	$s2,	1				# k++
	j	WHILE2						# jump back while
WHILE3:	slt	$t3,	$s3,	$s1				# j <= e2
	bne	$t3,	$zero,	END3				# not, then stop
	sll	$t2,	$s2,	2				# get offset of k
	add	$t2,	$a1,	$t2				# get address of A[k]
	sll	$t1,	$s1,	2				# t1 = get offset of j
	add	$t1,	$a0,	$t1				# get the address of Y[j]
	lw	$t1,	0($t1)					# t1 = Y[j]
	sw	$t1,	0($t2)					# A[k] =Y[i]
	addi	$s1,	$s1,	1				# j++
	addi	$s2,	$s2,	1				# k++
	j	WHILE3						# jump back to while3
END3:	addi	$s0,	$a2,	0				# i = s1
WHILE4:	slt	$t3,	$s3,	$s0				# i <= e2
	bne	$t3,	$zero,	RET				# not, then stop
	sll	$t4,	$s0,	2				# t4 = get offset of i
	add	$t0,	$a0,	$t4				# get address of Y[i]
	add	$t5,	$a1,	$t4				# get address of A[i]
	lw	$t5,	0($t5)					# get the value of A[i]
	sw	$t5,	0($t0)					# Y[i] = A[i]
	addi	$s0,	$s0,	1				# i++
	j	WHILE4						# jump back to while3
RET:	lw	$s0,	0($sp)					# get s0 from stack
	lw	$s1,	4($sp)					# get s0 from stack
	lw	$s2,	8($sp)					# get s0 from stack
	lw	$s3,	12($sp)					# get s0 from stack
	addi	$sp,	$sp,	20				# apply memory on stack for s register ra and fifth arg
	jr	$ra						# return method
