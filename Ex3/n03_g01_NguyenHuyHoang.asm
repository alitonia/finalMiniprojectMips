.include "n03_g01_NguyenHuyHoang_small_lib.asm"


##### define control block

.eqv MASK_CAUSE_COUNTER 0x00000400
.eqv MASK_CAUSE_KEYBOARD 0x0000034



#Keyboard 
.eqv KEY_CODE 0xFFFF0004
.eqv KEY_READY 0xFFFF0000

.eqv DISPLAY_CODE 0xFFFF000C
.eqv DISPLAY_READY 0xFFFF0008



# 7-led thingy
.eqv SEVENSEG_LEFT 0xFFFF0011
.eqv SEVENSEG_RIGHT 0xFFFF0010


# Time Counter
.eqv COUNTER 0xFFFF0013




.data
	input_string: .asciiz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	target_string: .asciiz "bo mon ky thuat may tinh"
	message:  .asciiz "Number of keyboard pressed: "
	new_line: .asciiz "\n"

	# length of target_string
	length: .word 24

	#number of new correct characters typed since last counter interrupt
	count_num: .word 0

	display_num: .word 0
	last_display: .word -1

	current_index: .word 0
	

# experimental
	print_interval_count:	 .word	0

	# delay between print count_num: 30 * print_interval
	print_interval: 			.word	 25


	

	




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.text
main:



	# Basic initialize


	sw $zero, current_index

	# in case target_string changed
	la $a0,target_string
	get_length_reg($a0)
	sw $v0, length



	# Enable the interrupt of TimeCounter of Digital Lab Sim
	li $t1, COUNTER
	sb $t1, 0($t1)


	li $k0, KEY_CODE
	li $k1, KEY_READY

	li $s0, DISPLAY_CODE
	li $s1, DISPLAY_READY
	# Keyboard Cause





	# idle loop, waiting to be interrupted
	Loop:
	nop
	nop
	nop
	nop

	#keyboard interrupt
WaitForKey:
	lw $t1, 0($k1)
	# $t1 = [$k1] = KEY_READY
	nop
	nop
	nop
	nop

	beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling

MakeIntR:
	teqi $t1, 1
	# if $t0 = 1 then raise an Interrupt


	addi $v0,$zero,32
	# BUG: must sleep to wait for Time
sleep:
	li $a0, 50
	syscall
	nop
	b Loop

end_main:
# sleep 300 ms
# WARNING: nop is mandatory here.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~










# interrupt handler
.ktext 0x80000180


# Find cause and jump appropriately

IntSR: #--------------------------------------------------------
# Temporary disable interrupt
#--------------------------------------------------------
dis_int:
	li $t1, COUNTER
	# BUG: must disable with Time Counter
	sb $zero, 0($t1)
	# no need to disable keyboard matrix interrupt
	#--------------------------------------------------------
	# Processing
	#--------------------------------------------------------
get_cause:
	mfc0 $t1, $13
	# $t1 = Coproc0.cause







IsCount:
	li $t2, MASK_CAUSE_COUNTER# if Cause value confirm
	#Counter..
	and $at, $t1,$t2
	beq $at,$t2, Counter_Intr



IsKeyBoard:
	li $t2, MASK_CAUSE_KEYBOARD # if Cause value confirm Key..
	and $at, $t1,$t2
	beq $at,$t2, Keyboard_Intr


others: 
	j end_process
	# other cases









	# Handle counter interrupt
Counter_Intr: 
	# Processing Counter Interrupt

magical_displayer:

	# check if display value have changed?

	# print_interval_count ++
	lw $t0, print_interval_count
	addi $t0, $t0, 1
	sw $t0, print_interval_count
	
	lw $t0, display_num
	lw $t1, last_display
	beq $t0, $t1, end_counter_interrupt
	sw $t0, last_display


	# display to 7 led
display_left:
	div $a0,$t0,10

	push_reg($ra)
	jal SHOW_7SEG_LEFT
	pop_reg($ra)

	nop

display_right:
	div $a0,$t0,10
	mul $t1,$a0,10
	sub $a0, $t0, $t1

	push_reg($ra)
	jal SHOW_7SEG_RIGHT
	pop_reg($ra)

	nop
	nop

end_counter_interrupt:
	nop
	push_reg($v0)
	push_reg($a0)
	push_reg($t1)
	push_reg($t2)
	
	lw $t1, print_interval_count
	lw $t2, print_interval

	slt $t1, $t1, $t2
	beq $t1, 1, no_print

	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 1
	lw $a0, count_num
	syscall
	
	li $v0, 4
	la $a0, new_line
	syscall


	sw $zero, count_num
	sw $zero, print_interval_count

no_print:	

	pop_reg($t2)
	pop_reg($t1)
	pop_reg($a0)
	pop_reg($v0)

	j end_process


SHOW_7SEG_LEFT: 
	push_reg($ra)
	push_reg($t0)

	jal decoder

	li $t0, SEVENSEG_LEFT # assign port's address
	sb $a0, 0($t0)

	pop_reg($t0)
	pop_reg($ra)
	# assign new value
	nop
	jr $ra
	nop

SHOW_7SEG_RIGHT: 
	push_reg($ra)
	push_reg($t0)

	jal decoder
	
	li $t0, SEVENSEG_RIGHT # assign port's address
	sb $a0, 0($t0)

	pop_reg($t0)
	pop_reg($ra)
	# assign new value
	nop
	jr $ra



# convert code number ----> signal 7-led
decoder:
	beq $a0, 0, zero_num
	beq $a0, 1, one_num
	beq $a0, 2, two_num
	beq $a0, 3, three_num
	beq $a0, 4, four_num
	beq $a0, 5, five_num
	beq $a0, 6, six_num
	beq $a0, 7, seven_num
	beq $a0, 8, eight_num
	beq $a0, 9, nine_num
	j else_num

	zero_num:
		li $a0,0x3F
		j end_num
	one_num:
		li $a0,0x06
		j end_num
	two_num:
		li $a0,0x5B
		j end_num
	three_num:
		li $a0,0x4F
		j end_num
	four_num:
		li $a0,0x66
		j end_num
	five_num:
		li $a0,0x6D
		j end_num
	six_num:
		li $a0,0x7D
		j end_num
	seven_num:
		li $a0,0x07
		j end_num
	eight_num:
		li $a0,0x7F
		j end_num
	nine_num:
		li $a0,0x6F
		j end_num
	else_num:
		li $a0,0x0
		j end_num
	end_num:
	jr $ra










# Handle keyboard interrupt

Keyboard_Intr:

ReadKey:

	lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE


WaitForDis: 
	lw $t2, 0($s1)
	nop
	nop
	nop
	nop
	#beq $t2, $zero, WaitForDis
	nop


ShowKey: 
	sw $t0, 0($s0)

	# press newline ----> refresh display
	seq $t1, $t0, 10
	beq $t1, $zero, new_value_handler


# procedure for refreshing
# change everything to original state
enter_procedure:

	sw $zero, display_num
	li $t1,-1
	sw $t1, last_display

	sw $zero, current_index

	li $t1,0
	la $a1, input_string		


# make input_string null again
refresh_string_loop:
	add $a2, $a1, $t1
	lb $t9, 0($a2)
	beq $t9, $zero, end_refresh_loop

	sb $zero, 0($a2)
	addi $t1, $t1, 1

	sw $zero, print_interval_count
	j refresh_string_loop
end_refresh_loop:
	j finish



# when new valid data is inserted
new_value_handler:
	# This part compare and 
	# add display num according to new input

	
	lw $t8, current_index
	lw $t1, length
	slt $t1, $t8, $t1
	beq $t1, 0, out_of_bound


	# This part compare and 
	# add display num according to new input
	la $a1, target_string
	add $a1, $a1, $t8
	lb $t1, 0($a1)
	la $a1,input_string
	add $a1, $a1, $t8
	sb $t0, 0($a1)

	addi $t8, $t8, 1
	sw $t8, current_index


	seq $t1, $t1, $t0
	lw $t0, display_num
	add $t0, $t0, $t1
	sw $t0, display_num
	
	
	beq $t1, 0, no_speed
	
	lw $t8, count_num
	addi $t8, $t8, 1
	sw $t8, count_num
	
no_speed:	

out_of_bound:
	
finish:
		nop
		nop
	j end_process






end_process:
	mtc0 $zero, $13
	# Must clear cause reg
en_int: #--------------------------------------------------------
	# Re-enable interrupt
	#--------------------------------------------------------
	li $t1, COUNTER
	sb $t1, 0($t1)
	#--------------------------------------------------------
	# Evaluate the return address of main routine
	# epc <= epc + 4
	#--------------------------------------------------------
next_pc:
	mfc0 $at, $14
	# $at = $at + 4
	# don't add 4 because it might jump out of loop @@
	mtc0 $at, $14
return: 
	eret
