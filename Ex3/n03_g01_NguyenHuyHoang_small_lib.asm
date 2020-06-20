# Push value in a register to stack 
.macro push_reg(%register)
	addi $sp, $sp, -4
	sw %register, 0($sp)
.end_macro 



# Pop value from stack to a register
.macro pop_reg(%register)
	lw %register, 0($sp)
	addi $sp, $sp, 4
.end_macro



# Get length of string at address stored in register,
# save value to $v0
.macro get_length_reg(%register)

   #Get length of string in $1 to $v0
   push_reg($a0)
   push_reg($t1)
   push_reg($t2)

__get_length__:

	move $a0, %register

	#set zero
	xor $v0, $zero $zero		#v0 = length = 0

__check_char__:
	add $t1, $a0, $v0			# t1 = &x[i]  =  a0 + t0
								
	lb $t2, 0($t1)				# t2 = x[i]

	beq $t2, $zero, __end_of_str__	# if (x[i] == null) break loop

	addi $v0, $v0, 1			# length ++;
	j __check_char__

__end_of_str__:
__end_of_get_length__:

	addi $v0, $v0, 0			#  correct length to saved register
	
	pop_reg($t2)
	pop_reg($t1)
	pop_reg($a0)


.end_macro