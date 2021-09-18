# Ringtone By using Mips, song: Beethoven - Fur Elise
# Changsong Li	
		
	.data
pitch:	.word 76,75,76,75,76,71,74,72,69,60,64,69,71,64,68,71,72,64,76,75,76,75,76,71,74,72,69,60,64,69,71,62,72,71,69
									# array for the song pitch

vol:	.word 90,90,90, 90,90,90, 90,90,90,66,74,82,90, 66,74,82,90,90,90,90,90, 90,90,90, 90,90,90,66,74,82,90, 66,74,82,90
									# array for the song vol

dur:	.word 150, 150,150,150,150,150,150,150,450,150,150,150,450,150,150,150,450,150,150, 150,150,150,150,150,150,150,450,150,150,160,450,150,150,150,450
									# array for the song duration

time:	.asciiz "Enter the times You would like to play the song: "	# prompt for user
	.align 2							# align the string
	
# end of data segment

#============================================================================================

# begin text segment

	.text
	
MAIN:	la	$a0,	time						# load the prompt
	addi	$v0,	$zero,	4					# prepare for printing
	syscall								# print prompt
	addi	$v0,	$zero,	5					# ask the input
	syscall								# get the input
	addi	$s0,	$v0,	0					# input(s0) = user input
	la	$s1,	pitch						# s1 = pitch
	la	$s2,	vol						# s2 = vol
	la	$s3,	dur						# s3 = dur
	addi	$a0,	$zero,	5000					# pause time = 5s
	addi	$v0,	$zero,	32					# set up pause
	syscall								# pause
	addi	$s4,	$zero,	0					# i = 0
FOR:	slt	$t0,	$s4,	$s0					# i < input
	beq	$t0,	$zero,	END					# false to end
	teq	$zero,	$zero						# trap
	addi	$s4,	$s4,	1					# i++
	j	FOR							# jump back to for	
END:	addi $v0, $zero, 10						# ready for exit
	syscall								# exit
	
# End of text

# ====================================================================================

# start exception

	.ktext 0x80000180    						# Trap handler!
	add  	$k0, 	$zero, 	$v0  					# Save $v0 value!
   	add 	$k1, 	$zero, 	$a0 					# Save $a0 value!
	addi 	$a2, 	$zero, 	2					# choose paino 2
	addi	$s5,	$zero,	0					# count = 0
	addi 	$v0, 	$zero, 	33					# set up for making sound
FOR2:	slti	$t0,	$s5,	35					# count < 33
	beq	$t0,	$zero,	END2					# false to end2
	sll	$t0,	$s5,	2					# get offset
	add	$t1,	$t0,	$s1					# get the address of pitch[count]
	lw	$a0,	0($t1)						# a0 = pitch
	add	$t1,	$t0,	$s3					# get the address of dur[count]
	lw	$a1,	0($t1)						# a1 = duration
	add	$t1,	$t0,	$s2					# get the address of vol[count]
	lw	$a3,	0($t1)						# a3 = volume
	syscall								# make sound
	addi	$s5,	$s5,	1					# count++
	j	FOR2							# jump back to FOR2
END2:	add 	$v0, 	$zero, 	$k0					# restore $v0
	add 	$a0, 	$zero, 	$k1					# restore $a0
	mfc0 	$k0,	$14 						# CP0 reg. $14 is addr. of trapping inst.!
	addi 	$k0,	$k0,	4 					# Add 4 to point to next instruction!
	mtc0 	$k0,	$14 						# Store new address back into $14!
	eret 								# Error return; set PC to value in $14