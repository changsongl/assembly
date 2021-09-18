# This program is an inseartion sort. It will read a number which is size of the integer array. The size won't be 
# larger than 20. After that, the program will read elements of the array. Then sort the array, and print the each
# elment.
#
# Changsong Li

	.data
arr:	.space	80						# apply the memory for the array with size 20 integers
	.align 2						# align data segment
size:	.asciiz	"Enter the number of elements in the array: "	# create a null-terminated string.
	.align 2						# align data segment after each string
num:	.asciiz	"Enter the array elements: "			# create a null-terminated string.
	.align 2						# align data segment after each string
sorted:	.asciiz	"The elements sorted in ascending order are: "	# create a null-terminated string.
	.align 2						# align data segment after each string
	
# end of data segment

# =================================================================================================

# begin text segment

	.text
MAIN:	la	$s0,	arr		# arr = load the address of the arr
	la	$a0,	size		# load the address of string size
	addi	$v0,	$zero,	4	# set up printing
	syscall				# printing for asking the how many numbers
	addi	$v0,	$zero,	5	# set up to read the how many numbers from user
	syscall				# read from user
	move	$s1,	$v0		# size = number from the user
	la	$a0,	num		# load the address of string num
	addi	$v0,	$zero,	4	# set up printing
	syscall				# printing for asking the how many numbers
	addi	$s2,	$zero,	0	# i = 0
FOR:	slt	$t0,	$s2,	$s1	# i < size
	beq	$zero,	$t0,	FOREND	# i >= size, stop for loop
	addi	$v0,	$zero,	5	# set up to read the number from user
	syscall				# read from user
	move	$s3,	$v0		# number = the number read from user
	sll	$t0,	$s2,	2	# get the offset
	add	$t0,	$s0,	$t0	# get the address of arr[i]
	sw	$s3,	0($t0)		# arr[i] = number
	addi	$s2,	$s2,	1	# i++
	j	FOR			# jump back to for
FOREND:	la	$a0,	sorted		# load the address of string sorted
	addi	$v0,	$zero,	4	# set up printing
	syscall				# printing for final sorted numbers prompt
	add	$a0,	$s0,	0	# pass arr address
	add	$a1,	$s1,	0	# pass the size
	jal	SORT			# inseartion_sort(arr,size)
	addi	$s2,	$zero,	0	# i = 0
PFOR:	slt	$t0,	$s2,	$s1	# i < size
	beq	$zero,	$t0,	PFEND	# i >= size, stop for loop
	sll	$t0,	$s2,	2	# get offset
	add	$t0,	$s0,	$t0	# get the address of arr[i]
	lw	$a0,	0($t0)		# $a0 = arr[i]
	addi	$v0,	$zero,	1	# set up printing integer
	syscall				# print the arr[i]
	addi	$a0,	$zero,	' '	# load the address of space
	addi	$v0,	$zero,	11	# set up printing character
	syscall				# printing for asking the how many numbers
	addi	$s2,	$s2,	1	# i++
	j	PFOR			# jump back to for
PFEND:	addi	$v0,	$zero,	10	# ready to end the program
	syscall				# exit
	
# end of the text

# =================================================================================================

SORT:	addi	$sp,	$sp,	-12	# make space on stack
	sw	$s0,	0($sp)		# save $s0
	sw	$s1,	4($sp)		# save $s1
	sw	$s2,	8($sp)		# save $s2
	addi	$s0,	$zero,	1	# c = 1
FORI:	addi	$t0,	$a1,	-1	# $t0 = n - 1
	slt	$t0,	$t0,	$s0	# c <= n - 1
	bne	$t0,	$zero,	ENDFOR	# stop when c > n - 1
	addi	$s1,	$s0,	0	# d = c
WHILE:	slt	$t0,	$zero,	$s1	# d > 0
	beq	$t0,	$zero,	ENDW	# 0 >= d stop while
	sll	$t0,	$s1,	2	# get the offset
	add	$t0,	$a0,	$t0	# $t0 get the address of array[d]
	lw	$t2,	0($t0)		# get the element of array[d]
	addi	$t1,	$s1,	-1	# $t1 = d - 1
	sll	$t1,	$t1,	2	# get offset
	add	$t1,	$a0,	$t1	# $t1 get the address of array[d-1]
	lw	$t3,	0($t1)		# get the element of array[d-1]
	slt	$t4,	$t2,	$t3	# array[d] < array[d-1]
	beq	$t4,	$zero,	ENDW	# stop when both condition fails
	addi	$s2,	$t2,	0	# t = array[d]
	sw	$t3,	0($t0)		# array[d] = array[d-1]
	sw	$s2,	0($t1)		# array[d-1] = t
	addi	$s1,	$s1,	-1	# d--
	j	WHILE			# jump back to while
ENDW:	addi	$s0,	$s0,	1	# c++
	j	FORI			# jump back to for
ENDFOR:	lw	$s0,	0($sp)		# $s0 load previous value
	lw	$s1,	4($sp)		# $s1 load previous value
	lw	$s2,	8($sp)		# $s2 load previous value
	addi	$sp,	$sp,	12	# oop space out from stack
	jr	$ra			# return
