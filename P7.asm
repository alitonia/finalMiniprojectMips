.include "miniprojectUtils.asm"
.include "P7_Resource.asm"

.data
	promptInput:		.asciiz "Enter a MIPS (basic) instruction: "
	promptExit:		.asciiz "Continue?"
	emptyMessage:	.asciiz "Empty input"
	inputString: 		.space 256
.text

main:
	li $v0, 54
	la $a0, promptInput
	la $a1, inputString
	la $a2, 256
	syscall
	
	bnez $a1, emptyInput
	la $a0, inputString
	trim_space_reg($a0)
	split_by_literal_separator($a0, ' ')  #-> opcode in $a2
	opcode_in_ee:
		la $a1, ee
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_ef
		valid_ee($a3)
		beqz $v0, opcode_in_ef
		j find_cycle
	opcode_in_ef:
		la $a1, ef
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_eec
		valid_ef($a3)
		beqz $v0, opcode_in_eec
		j find_cycle
	opcode_in_eec:
		la $a1, eec
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_eei
		valid_eec($a3)
		beqz $v0, opcode_in_eei
		j find_cycle
	opcode_in_eei:
		la $a1, eei
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_eee
		valid_eei($a3)
		beqz $v0, opcode_in_eee
		j find_cycle
	opcode_in_eee:
		la $a1, eee
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_es16_i
		valid_eee($a3)
		beqz $v0, opcode_in_es16_i
		j find_cycle
	opcode_in_es16_i:
		la $a1, es16_i
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_fs16
		valid_es16_i($a3)
		beqz $v0, opcode_in_fs16
		j find_cycle	
	opcode_in_fs16:
		la $a1, fs16
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_fe
		valid_fs16($a3)
		beqz $v0, opcode_in_fe
		j find_cycle
	opcode_in_fe:
		la $a1, fe
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_ff1
		valid_fe($a3)
		beqz $v0, opcode_in_ff1
		j find_cycle
	opcode_in_ff1:
		la $a1, ff_1
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_ff2
		valid_ff($a3)
		beqz $v0, opcode_in_ff2
		j find_cycle
	opcode_in_ff2:
		la $a1, ff_2
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_ffc
		valid_ff($a3)
		beqz $v0, opcode_in_ffc
		j find_cycle
	opcode_in_ffc:
		la $a1, ffc
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_ffi
		valid_ffc($a3)
		beqz $v0, opcode_in_ffi
		j find_cycle
	opcode_in_ffi:
		la $a1, ffi
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_fff
		valid_ffi($a3)
		beqz $v0, opcode_in_fff
		j find_cycle
	opcode_in_fff:
		la $a1, fff
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_i
		valid_fff($a3)
		beqz $v0, opcode_in_i
		j find_cycle
	opcode_in_i:
		la $a1, i
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_i8
		valid_i($a3)
		beqz $v0, opcode_in_i8
		j find_cycle
	opcode_in_i8:
		la $a1, i8
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_is16_i
		valid_i8($a3)
		beqz $v0, opcode_in_is16_i
		j find_cycle
	opcode_in_is16_i:
		la $a1, is16_i
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_is16
		valid_is16_i($a3)
		beqz $v0, opcode_in_is16
		j find_cycle
	opcode_in_is16:
		la $a1, is16
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iu16
		valid_is16($a3)
		beqz $v0, opcode_in_iu16
		j find_cycle
	opcode_in_iu16:
		la $a1, iu16
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_if
		valid_iu16($a3)
		beqz $v0, opcode_in_if
		j find_cycle
	opcode_in_if:
		la $a1, if
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_ii
		valid_if($a3)
		beqz $v0, opcode_in_ii
		j find_cycle
	opcode_in_ii:
		la $a1, ii
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iii
		valid_ii($a3)
		beqz $v0, opcode_in_iii
		j find_cycle
	opcode_in_iii:
		la $a1, iii
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iic
		valid_iii($a3)
		beqz $v0, opcode_in_iic
		j find_cycle
	opcode_in_iic:
		la $a1, iic
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iis16
		valid_iic($a3)
		beqz $v0, opcode_in_iis16
		j find_cycle
	opcode_in_iis16:
		la $a1, iis16
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iiu5
		valid_iis16($a3)
		beqz $v0, opcode_in_iiu5
		j find_cycle
	opcode_in_iiu5:
		la $a1, iiu5
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iiu16
		valid_iiu5($a3)
		beqz $v0, opcode_in_iiu16
		j find_cycle
	opcode_in_iiu16:
		la $a1, iiu16
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_iil
		valid_iiu16($a3)
		beqz $v0, opcode_in_iil
		j find_cycle
	opcode_in_iil:
		la $a1, iil
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_il
		valid_iil($a3)		
		beqz $v0, opcode_in_il
		j find_cycle
	opcode_in_il:
		la $a1, il
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_cl
		valid_il($a3)
		beqz $v0, opcode_in_cl
		j find_cycle
	opcode_in_cl:
		la $a1, cl
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_cee
		valid_cl($a3)
		beqz $v0, opcode_in_cee
		j find_cycle
	opcode_in_cee:
		la $a1, cee
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_cff
		valid_cee($a3)
		beqz $v0, opcode_in_cff
		j find_cycle
	opcode_in_cff:
		la $a1, cff
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_l
		valid_cff($a3)
		beqz $v0, opcode_in_l
		j find_cycle	
	opcode_in_l:
		la $a1, l
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_none
		valid_l($a3)
		beqz $v0, opcode_in_none
		j find_cycle
	opcode_in_none:
		la $a1, none
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, opcode_in_u16
		valid_none($a3)
		beqz $v0, opcode_in_u16
		j find_cycle
	opcode_in_u16:
		la $a1, u16
		check_substring_appearance($a1, $a2)
		beq $v0 ,0, not_found
		valid_u16($a3)
		beqz $v0, not_found
	
	find_cycle:
	
	opcode_three_cycle_1:
		la $a1, three_cycle_1
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_three_cycle_2
		li $a0, 3
		j found
	opcode_three_cycle_2:
		la $a1, three_cycle_2
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_three_cycle_3
		li $a0, 3
		j found
	opcode_three_cycle_3:
		la $a1, three_cycle_3
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_three_cycle_4
		li $a0, 3
		j found
	opcode_three_cycle_4:
		la $a1, three_cycle_4
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_four_cycle_1
		li $a0, 3
		j found
	opcode_four_cycle_1:
		la $a1, four_cycle_1
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_four_cycle_2
		li $a0, 4
		j found
	opcode_four_cycle_2:
		la $a1, four_cycle_2
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_four_cycle_3
		li $a0, 4
		j found
	opcode_four_cycle_3:
		la $a1, four_cycle_3
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_four_cycle_4
		li $a0, 4
		j found
	opcode_four_cycle_4:
		la $a1, four_cycle_4
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_five_cycle
		li $a0, 4
		j found
	opcode_five_cycle:
		la $a1, five_cycle
		check_substring_appearance($a1, $a2)
		beqz $v0, opcode_undefined_cycle
		li $a0, 5
		j found
	opcode_undefined_cycle:
		la $a1, undefined_cycle
		check_substring_appearance($a1, $a2)
		li $a0, 0
		
	found:
		print_literal("Opcode: ")
		print_string_reg($a2)
		print_literal(", valid\n")
		print_literal("Number of cycles: ")
		bnez $a0, print_cycle
		print_literal("undefined\n")
		j endMain
	print_cycle:
		li $v0, 1
		syscall
		print_literal("\n")
		j endMain
		
	not_found:
		print_literal("Invalid instruction\n")
	
	endMain:
		li $v0, 50
		la $a0, promptExit
		syscall
		beqz $a0, main
		print_literal("Program exitting ...")
		li $v0, 10
		syscall
		
emptyInput:
	li $v0, 55
	la $a0, emptyMessage
	li $a1, 2
	syscall
	j endMain
