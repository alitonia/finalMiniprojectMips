#Filename:		n07_g01_PhiHoangLong_Utils.asm
#Purpose:		define utilities which will be used in the miniproject 7
#Author:			Phi Hoang Long		20184288
#
#Subprogram list:
#				append_label_string_reg
#				append_label_literal
#				check_int_reg_range
#				check_label
#					check_first_char_label
#					check_char_label
#				check_substring_appearance
#				convert_num_hex
#				get_string_reg_length
#				is_hexa
#				is_num
#				pop_reg
#				print_literal
#				print_string_reg
#				push_reg
#				reg_char_first_pos
#				split_by_literal_separator
#				strcmp
#				trim_space_reg

#Subprogram: 	append_label_string_reg
#purpose:		append a string from a register to a given label
#input:			%destination - destination label
#				%source - input register contains string to be appended
#output:			%destination = %destination.append(%source)
#side effects:		none

.macro append_label_string_reg(%label, %source)
.text
	push_reg($v0)
	push_reg($a0)
	push_reg($a1)

	la $a1, (%source)			#source
	la $a0, %label		#destination
	get_string_reg_length($a0)
	add $a0, $a0, $v0
	
append:
	lb $v0, ($a1)			#get the current char
	beqz $v0, done			#if char is EOS, goto done
	sb $v0, ($a0)				#store the current char
	addi $a0, $a0, 1			#advance destination pointer
	addi $a1, $a1, 1			#advance source pointer
	j append

done:
	sb $zero, ($a0)			#add EOS to %label
	pop_reg($a1)
	pop_reg($a0)
	pop_reg($v0)
.end_macro

#Subprogram: 	append_label_literal
#purpose:		append a string to a label
#input:			%label, %string
#output:			%label = %label.append(%string)
#side effects:		none

.macro append_label_literal(%label, %string)
.data
	__string__: .asciiz %string
.text
	push_reg($v0)
	
	la $v0, __string__
	append_label_string_reg(%label, $v0)

	pop_reg($v0)
.end_macro

#Subprogram:		check_int_reg_range
#Purpose:		check if an integer stored in a register is in input range
#Input:			%int_register - integer to check
#				%lower_bound (literal)
#				%upper_bound (literal)
#Output:			$v0 = 1 if true
#					  0 if false

.macro check_int_reg_range(%int_register, %lower_bound, %upper_bound)
	push_reg($t0)
	push_reg($t1)
	push_reg($t2)
	move $t0, %int_register
	li $t1, %lower_bound
	li $t2, %upper_bound
	blt $t0, $t1, not_in_range		#if value > upper_bound -> false
	bgt $t0, $t2, not_in_range		#if value < lower_bound -> false
	in_range:						#else true
		li $v0, 1
		j end_check_int_reg_range
	not_in_range:
		li $v0, 0
		j end_check_int_reg_range
	end_check_int_reg_range:
	pop_reg($t2)
	pop_reg($t1)
	pop_reg($t0)
.end_macro

#Subprogram:		check_label
#Purpose:		check if a label is in valid form or not
#Input:			%string_reg
#Output:			$v0 = 1 if valid
#					  0 if invalid

.macro check_label(%string_reg)
	#65 -90, 97-122, 48-58, 95
	push_reg($a0)
	push_reg($t0)
	push_reg($v1)
	push_reg($t1)
	push_reg($a0)
	push_reg($a1)
	move $a0, %string_reg						# a0 = string_reg
	li $t0, 0									# set t0 = i = 0 (counter)
	get_string_reg_length(%string_reg) 		
	move $v1, $v0								# v1 = v0 = length
	check_label_loop:
		slt $t1, $t0, $v1						# t1 = (t0 < v1)
		beq $t1, 0, end_check_label_loop			# if t0 >= v1 -> label valid -> done
		add $a1, $a0, $t0						# a1 = &string [i]
		lb $t1, 0($a1)							# t1 = char at i (ascii value)
		bne $t0, $0, normal_routine				# if t0 != 0 (not first char) -> normal check
		check_first_char_label($t1)				# else check first char (first char cannot be a number) -> v0
		beq $v0, 0, invalid						# if v0 = 0, invalid
		j end_check_char_iter					# else start checking from the second char
		normal_routine:
			check_char_label($t1)				# check each char from label -> v0
			beq $v0, 0, invalid					# if v0 = 0, invalid
		end_check_char_iter:
			addi $t0, $t0, 1					# i++
			j check_label_loop
		end_check_label_loop:
			li $v0, 1
			j end_check_label
	invalid:
		li $v0, 0
	end_check_label:
		pop_reg($a1)
		pop_reg($a0)
		pop_reg($t1)
		pop_reg($v1)
		pop_reg($t0)
		pop_reg($a0)
.end_macro

#make sure that the first character in a label is not a number
.macro check_first_char_label(%register_value)
	push_reg($t0)
	push_reg($t1)
	push_reg($t2)
	
	move $t0, %register_value

	sgt $t1, $t0, 64						
	slti $t2, $t0, 91							
	and $t1, $t1, $t2				
	beq $t1, 1, valid				# if 64 < t0 < 91, valid
								# else
	sgt $t1, $t0, 96						
	slti $t2, $t0, 123						
	and $t1, $t1, $t2				
	beq $t1, 1, valid				# if 96 < t0 < 123, valid
								# else
	seq $t1, $t0, 95				
	beq $t1, 1, valid				# if (t0 == 95) -> valid
								# else invalid
	li $v0, 0
	j done
	valid:
		li $v0, 1
	done:
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#check every character if valid in a label
.macro check_char_label(%register_value)
	push_reg($t0)
	push_reg($t1)
	push_reg($t2)
	push_reg(%register_value)
	pop_reg($t0)

	sgt $t1, $t0, 47
	slti $t2, $t0, 59
	and $t1, $t1, $t2
	beq $t1, 1, valid			# if (47 < t0 < 59) , valid
							# else
	sgt $t1, $t0, 64
	slti $t2, $t0, 91
	and $t1, $t1, $t2
	beq $t1, 1, valid			# if (64 < t0 < 91), valid
							# else
	sgt $t1, $t0, 96
	slti $t2, $t0, 123
	and $t1, $t1, $t2
	beq $t1, 1, valid			# if (96 < t0, 123), valid
							# else
	seq $t1, $t0, 95
	beq $t1, $1, valid			# if t0 == 95 , valid
							# else invalid
	li $v0,0
	j done
	valid:
		li $v0,1
	done:
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#Subprogram:		check_substring_appearance
#Purpose:		check if a substring belongs to a given string in which words are split by spaces
#Input:			%string_reg
#				%substring_reg
#Output:			$v0 = 1 if found
#					  0 if not found

.macro check_substring_appearance(%string_reg, %substring_reg)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	move $t2, %string_reg					# t2 : string
	move $t3, %substring_reg				# t3 : substring to find
	split_by_literal_separator($t2, ' ') 			# first half -> a2, second half -> a3
	strcmp($a2, $t3)						
	beqz $v0, found						# if a2 = t3 -> found, else
	# split string into multiple components and linear search
	loop:
		split_by_literal_separator($a3, ' ')		# split string -> first half : a2, second half : a3
		lb $t0, ($a2)				
		beq $t0, 0, not_found				# if t0 = null (end of string), not found
		strcmp($a2, $t3)					# else
		beqz $v0, found					# if a2 = t3 -> found , else continue
		j loop
	found:
		addi $v0, $zero, 1
		j done
	not_found:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Subprogram:		convert_num_hex
#Purpose:		convert a valid string of 16-bit hexadecimal to decimal
#Input:			%register_string
#Output:			$v0

.macro convert_num_hex(%register_string)
	push_reg($t0) 	# i
	push_reg($t1)	# char value	
	push_reg($a0)	# address origin
	push_reg($a1)	# address current char
	push_reg($t2)	# sum
	push_reg($t3)	# condition
	push_reg($t4)   # condition
	push_reg($v1) 	# first_num (if len = 8)
	push_reg($ra)

	# a0 = %register_string
	move $a0, %register_string
	get_string_reg_length($a0) # ---> v0
	li $t0, 0  # i = 0
	li $t2, 0  # sum = 0
	li $v1,0   # first num = 0
	__convert_num_hex_loop__:
		beq $t0, $v0, __convert_num_hex_end_loop__
		add $a1, $a0, $t0
		lb $t1, 0($a1)  # t1 = a[i]
		# check for negative case
		seq $t3, $t0, 0
		seq $t4, $v0, 8
		and $t3, $t3, $t4
		beq $t3, 1, __is_num_might_neg_case
	__convert_num_hex_okay__:
		jal __convert_num_hex_convert__
	__convert_num_hex_sum__:
		mul $t2, $t2, 16
		add $t2, $t2, $t1
	__convert_num_hex_end_iter__:
		addi $t0, $t0, 1
		j __convert_num_hex_loop__
	__convert_num_hex_end_loop__:
		move $v0,$t2
		# first_num * 10^7 - rest
		j __convert_num_hex_end__
	__is_num_might_neg_case:
		# 48-57
		sgt $t3, $t1, 47
		slti $t4, $t1, 58
		and $t3, $t3, $t4
		beq $t3, 1, __convert_num_hex_okay__
		jal __convert_num_hex_convert__
		addi $t2, $t1, 0 # first num -> v1
		li $t1, 8
		sub $t2, $t2, 8
		sub $t2, $t1, $t2
		# t2 = -(2^3 - rest)
		mul $t2, $t2, -1
		j __convert_num_hex_end_iter__
	__convert_num_hex_convert__:
		 #65-70
		 #97-102
	 	beq $t1, 65, __convert_num_hex_10_case__
		beq $t1, 66, __convert_num_hex_11_case__
		beq $t1, 67, __convert_num_hex_12_case__
		beq $t1, 68, __convert_num_hex_13_case__
		beq $t1, 69, __convert_num_hex_14_case__
	 	beq $t1, 70, __convert_num_hex_15_case__

	 	beq $t1, 97, __convert_num_hex_10_case__
		beq $t1, 98, __convert_num_hex_11_case__
		beq $t1, 99, __convert_num_hex_12_case__
		beq $t1, 100, __convert_num_hex_13_case__
		beq $t1, 101, __convert_num_hex_14_case__
		beq $t1, 102, __convert_num_hex_15_case__
	 
		sub $t1, $t1, 48
	 	jr $ra
	__convert_num_hex_10_case__:
		li $t1, 10
		jr $ra
	__convert_num_hex_11_case__:
		li $t1, 11
		jr $ra
	__convert_num_hex_12_case__:
		li $t1, 12
		jr $ra
	__convert_num_hex_13_case__:
		li $t1, 13
		jr $ra
	__convert_num_hex_14_case__:
		li $t1, 14
		jr $ra
	__convert_num_hex_15_case__:
		li $t1, 15
		jr $ra
	__convert_num_hex_end__:
		pop_reg($ra)
		pop_reg($v1) 	# first_num (if len = 8)
		pop_reg($t4)   # immediate
		pop_reg($t3)	# condition
		pop_reg($t2)	# sum
		pop_reg($a1)	# address current char
		pop_reg($a0)	# address origin
		pop_reg($t1)	# char value	
		pop_reg($t0) 	# i
.end_macro

#Subprogram:		get_string_reg_length
#Purpose:		find length of a string stored in a register
#Input:			%reg - register contains a string
#Output:			$v0 = length

.macro get_string_reg_length(%reg)
	push_reg($a0)
	push_reg($t1)
	push_reg($t2)
	
	get_length:
		move $a0, %reg
		xor $v0, $zero, $zero				#reset $v0 = 0 (i, length)	
	check_char:
		add $t1, $a0, $v0					#t1 = &str[i]  
		lb $t2, 0($t1)						#t2 = str[i]
		beq $t2, $zero, end_of_str			#if (str[i] == null) done
		addi $v0, $v0, 1					#else i++
		j check_char	
	end_of_str:
	end_of_get_length:
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($a0)
.end_macro

#Subprogram:		is_hexa
#Purpose:		check if a string stored in a register is a valid hexadecimal or not
#Input:			%register_string
#Output:			$v1 = 0 , $v0 = 0 if invalid
#					  1 , $v0 = num(decimal) if valid 

.macro is_hexa(%register_string)
.data
	hexa_part: .space 100
.text
	push_reg($t0)
	push_reg($t1)
	push_reg($t2)
	push_reg($t3)
	push_reg($t4)
	push_reg($t5)
	push_reg($a0)
	push_reg($a1)
	
	la $a1, hexa_part
	li $t0, 0						# count length
	move $a0, %register_string
	# check 0x
	lb $t5, 0($a0)					# get first char -> t5
	bne $t5, '0', invalid				# if t5 != '0' -> invalid
	addi $a0, $a0, 1				# else move to next char
	addi $t0, $t0, 1				# length++
	lb $t5, 0($a0)					# get second char -> t5
	beq $t5, 'x', skip				 
	beq $t5, 'X', skip				# if t5 == 'x' or t5 == 'X' -> skip
	j invalid						# else invalid
	# check after 0x
	skip:
		addi $t0, $t0, 1			# length++
		addi $t1, $a0, 1
		li $t4, -1					# count zeroes
	get_first_non_zero_char:
		addi $a0, $a0, 1
		addi $t4, $t4, 1
		lb $t5, 0($a0)
		beq $t5, 0, check_current_length			# if reach end_of_string without finding first_non_zero -> check length of zeroes
		beq $t5, '0', get_first_non_zero_char		# if found a zero_char, continue	
		move $t1, $t5
		addi $t0, $t0, 1
		move $a1, $a0
		j loop
	check_current_length:
		get_string_reg_length($t1)				# length = v0
		beqz $v0, invalid						# if length = 0 (string empty) -> invalid
		append_label_literal(hexa_part, "0")
		la $a1, hexa_part
		j valid								# else valid (0x000...)
	loop:
		addi $a0, $a0, 1			# move to next char -> t5
		lb $t5, 0($a0)				
		bnez $t5, continue			# else if t5 != '\0' , check char valid
		j valid					# else valid
	#0-9, A-F, a-f
	continue:
		blt $t5, '0', invalid
		bgt $t5, 'f', invalid
		ble $t5, '9', check_length
		blt $t5, 'A', invalid
		ble $t5, 'F', check_length
		blt $t5, 'a', invalid
		
	check_length:
		addi $t0, $t0, 1				# get currrent length
		bgt $t0, 10, invalid				# if current length > 10 -> invalid
		beq $t0, 10, check_first_char
		j loop						# else continue check char
	check_first_char:
		sge $t2, $t1, 56
		sle $t3, $t1, 57
		and $t2, $t2, $t3
		beq $t2, 1, check_if_zero_exist	# if t1 == 8 or t1 == 9, check zero
		sge $t2, $t1, 65
		sle $t3, $t1, 70
		and $t2, $t2, $t3				
		beq $t2, 1, check_if_zero_exist	# if A <= t1 <= F, check zero
		sge $t2, $t1, 97
		sle $t3, $t1, 102
		and $t2, $t2, $t3
		beq $t2, 1, check_if_zero_exist	# if a <= t1 <= f, check zero
		j loop
	check_if_zero_exist:
		beq $t4, 0, loop				# if there is no zero
		j invalid
	invalid:
		addi $v0, $0, 0
		addi $v1, $0, 0
		j done
	valid:
		# a1 contains hexa part (without 0)
		convert_num_hex($a1)	
		addi $v1, $0, 1
	done:
		pop_reg($a1)
		pop_reg($a0)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#Subprogram:		is_num
#Purpose:		check if a string stored in a register is a valid integer or not
#Input:			%register_string
#Output:			$v1 = 0, $v0 = 0 if invalid
#					  1, $v0 = num(decimal) if valid

.macro is_num(%register_string)
	push_reg($t0) 	# i
	push_reg($t1)	# char value	
	push_reg($a0)	# address origin
	push_reg($a1)	# address current char
	push_reg($t2)	# sum
	push_reg($t3)	# condition

	# a0 = %register_string
	move $a0, %register_string
	get_string_reg_length($a0)			 # ---> v0
	li $t0, 0							# t0 = i = 0
	li $t2, 0
	is_num_loop:
		slt $t3, $t0, $v0				
		beqz $t3, is_num_end_loop		# if t0 = \0 -> complete
		add $a1, $a0, $t0
		lb $t1, 0($a1)					# a1 = str[i]
		#check and convert valid char
		#48 - 57						# 48 : zero 
		beq $t0, 0, first_iter				# if t0 is first_char , explicitly check (sign possible), else normal check
		slti $t3, $t1, 48			
		beq $t3, 1, invalid				# if t1 < 48 -> invalid
		sgt $t3, $t1, 57
		beq $t3, 1, invalid				# if t1 > 57 -> invalid
		sub $t1, $t1, 48				
		# ----> char -> num
	is_num_action:
		mul $t2, $t2, 10				# multiply by 10
		add $t2, $t2, $t1				# then plus with the old value
		j is_num_end_iter
	first_iter:
		beq $t1, 45, neg_case			# 45 : minus sign
		# check if digit is in [0, 9]
		slti $t3, $t1, 48					
		beq $t3, 1, invalid
		sgt $t3, $t1, 57
		beq $t3, 1, invalid
		sub $t1, $t1, 48				# get value of digit depend on its string form
		j pos_case
	# v1 = sign
	neg_case:
		li $v1, -1	
		j is_num_end_iter
	pos_case:
		li $v1, 1
		j is_num_action
	is_num_end_iter:
		addi $t0, $t0, 1				# i++
		j is_num_loop
	is_num_end_loop:
		mul $v0, $t2, $v1				# multiply with sign
		li $v1, 1
		j is_num_end
	invalid:
		li $v1, 0
		li $v0, 0
	is_num_end:
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($a1)
		pop_reg($a0)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#Subprogram:		pop_reg
#Purpose:		pop from stack
#Input:			%reg - register contains popped value
#Output:			$sp is popped into %reg

.macro pop_reg(%reg)
	lw %reg, 0($sp)
	addi $sp, $sp, 4
.end_macro

#Subprogram:		print_literal
#Purpose:		print an input literal string to console
#Input:			%string 
#Output:			print %string to console

.macro print_literal(%string)
.data
	string: .asciiz %string
.text
	push_reg($v0)
	push_reg($a0)
	li $v0, 4
	la $a0, string
	syscall
	pop_reg($a0)
	pop_reg($v0)
.end_macro

#Subprogram:		print_string_reg
#Purpose:		print a string stored in a register to console
#Input:			%string_reg
#Output:			%string_reg is printed to console

.macro print_string_reg(%string_reg)
	push_reg($v0)
	push_reg($a0)
	li $v0, 4
	move $a0, %string_reg
	syscall
	pop_reg($a0)
	pop_reg($v0)
.end_macro

#Subprogram:		push_reg
#Purpose:		push a register into stack
#Input:			%reg - register to push
#Output:			$sp with new peek %reg

.macro push_reg(%reg)
	addi $sp, $sp, -4
	sw %reg, 0($sp)
.end_macro

#Subprogram:		reg_char_first_pos
#Purpose:		find the first position of a character in a string
#Input:			%char_reg - register contains a character
#				%string_reg - register contains a string
#Output:			$v0 = pos

.macro reg_char_first_pos(%char_reg, %string_reg)
	push_reg($t0)					#t0 : store character to find
	push_reg($t1)					#t1 : counter
	push_reg($t2)					#t2: temp var
	push_reg($t3)					#t3 : temp var
	push_reg($a0)					#a0 : store string

	find_pos:
		move $t0, %char_reg
		move $a0, %string_reg
		addi $v0, $zero, 0				#set v0 = 0
		addi $t1, $zero, 0				#set t1 = i = 0
	check_char:
		add $t2, $a0, $t1				
		lb $t3, 0($t2)					# t3 = str[i]
		beq $t3, 0, not_found_pos		# if t3 = \0 -> not found
		beq $t3, $t0, found_pos			# if t3 = t0 -> found
		addi $t1, $t1, 1				# else i++	
		j check_char
	not_found_pos:
		addi $v0, $zero, -1	
		j end_of_find_pos
	found_pos:
		move $v0, $t1
	end_of_find_pos:
		pop_reg($a0)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#Subprogram:		split_by_literal_separator
#Purpose:		split a given string into 2 substrings, using separator character, remove redundant spaces if possible
#Input:			%string_reg - register contains string
#				%char - separator character
#Output:			$a2 - contains the first string split by this function
#				$a3 - contains the rest substring

.macro split_by_literal_separator(%string_reg, %char)
.data
	substring: .space 100
.text
	push_reg($t0)				# t0 : separator
	push_reg($t1)				# t1 : first position of separator
	push_reg($t2)				# t2 : temp counter
	push_reg($t3)				# t3 : temp var
	push_reg($a0)				# a0 : original string			
	push_reg($v0)				# v0 : first half split string
	move $a0, %string_reg
	li $t0, %char
	la $a2, substring
	reg_char_first_pos($t0, $a0) 	# find separator first position -> v0
	beq $v0, -1, return			# if not found -> return 
	move $t1, $v0				# t1 = v0
	addi $t2, $zero, 0			#set t2 = i = 0
	append:	
		add $t3, $a0, $t2				# t3 = &str[i]
		lb $t3, 0($t3)			
		beq $t2, $t1, end_append		# if i = pos break
		sb $t3, ($a2)					# else substr[j] = t3
		addi $t2, $t2, 1				# i++
		addi $a2, $a2, 1				# j++
		j append
	 end_append:
	 	sb $zero, ($a2)				# append \0 at the end of substring
		la $a2, substring				# load first half split string to a2
		addi $t2, $t2, 1				# get the next position
	 	add $a3, $a0, $t2				# load second half split string to a3
	 	trim_space_reg($a2)
	 	trim_space_reg($a3)
	 	j done 
	 return:							# string cannot be split 
	 	move $a2, $a0				# keep a2 = origin string
	 	get_string_reg_length($a0)
	 	add $a3, $a0, $v0				# a3 = \0
	 done:
		pop_reg($v0)
		pop_reg($a0)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#Subprogram:		strcmp
#Purpose:		compare 2 strings in alphabetic format
#Input:			%reg1 - contains a string 1
#				%reg2 - contains a string 2
#Output:			$v0 = 0 if (string 1 == string 2)
#					  1 if (string 1 != string 2)

.macro strcmp(%reg1, %reg2)
	push_reg($t0)
	push_reg($t1)
	push_reg($t2)
	push_reg($t3)
	
	move $t0, %reg1
	move $t1, %reg2
	#compare each character in 2 strings
	cmploop:
		lb $t2, ($t0)
		lb $t3, ($t1)
		bne $t2, $t3, cmpne
		beq $t2, $zero, cmpeq
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j cmploop
	cmpne:
		addi $v0, $zero, 1
		j end_cmp
	cmpeq:
		addi $v0, $zero, 0
	end_cmp:
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t1)
		pop_reg($t0)
.end_macro

#Subprogram:		trim_space_reg
#Purpose:		remove all beginning and ending spaces from a string stored in a register
#Input:			%reg
#Output:			%reg removed all above spaces

.macro trim_space_reg(%reg)
.data
	result: .space 100
.text
	push_reg($t0)				#temp character, counter
	push_reg($t1)				#original string
	push_reg($t2)				#temp character, first non-space position
	push_reg($t3)				#temp character, last non_space position
	push_reg($t4)				#temp value, result string
	
	move $t1, %reg
	addi $t2, $zero, 0									# assume first non-space position = t2 = i = 0 (first position)
	first_non_space_pos:
		add $t3, $t1, $t2								# t3 = str[i]
		lb $t3, ($t3)
		beq $t3, 0, done								# if t3 = \0 -> complete -> no space in string
		beq $t3, 32, continue_check_first_non_space_pos		# else if t3 = 32 (space), continue
		beq $t3, 9, continue_check_first_non_space_pos		# else if t3 = 9 (tab), continue
		beq $t3, 10, continue_check_first_non_space_pos		# else if t3 = 10 (newline), continue
		j found_first_non_space_pos						# else found first non-space position
	continue_check_first_non_space_pos:
		addi $t2, $t2, 1								# i++
		j first_non_space_pos
	found_first_non_space_pos:
		move $t4, $t2									# assume last non-space position = t4 = i = first non-space position
	last_non_space_pos:
		add $t0, $t1, $t4								# t0 = str[i]
		lb $t0, ($t0)
		beq $t0, 0, found_last_non_space_pos				# if t0 = \0 -> complete -> return the latest non_space position
		beq $t0, 32, continue_check_last_non_space_pos		# else if t0 = 32 (space), continue
		beq $t0, 9, continue_check_last_non_space_pos		# else if t0 = 9 (tab), continue
		beq $t0, 10, continue_check_last_non_space_pos		# else if t0 = 10 (newline), continue
		move $t3, $t4									# else keep track of the latest non_space position to t3
	continue_check_last_non_space_pos:
		addi $t4, $t4, 1								# i++
		j last_non_space_pos	
	found_last_non_space_pos:
		la $t4, result									# load result var and start appending process
		addi $t3, $t3, 1
	# append from first_non_space_pos to last_non_space_pos to result
	append:
		add $t0, $t1, $t2
		lb $t0, ($t0)									# t0 = str[i]
		beq $t2, $t3, end_of_append						# if t0 = last_non_space_pos +1 -> finish appending
		sb $t0, ($t4)									# result[j] = t0
		addi $t2, $t2, 1								# i++
		addi $t4, $t4, 1								# j++
		j append
	end_of_append:	
		sb $zero, ($t4)									# append \0 to result
	  	la %reg, result									# save result to the argument register
	 done:
	   	pop_reg($t4)
	   	pop_reg($t3)
	   	pop_reg($t2)
	   	pop_reg($t1)
	   	pop_reg($t0)
.end_macro
