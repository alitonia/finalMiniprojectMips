.data
	cee:		.asciiz "c.eq.d c.le.d c.lt.d"
	cff:		.asciiz "c.eq.s c.le.s c.lt.s"
	cl:		.asciiz "bc1f bc1t"
	ee:		.asciiz "abs.d c.eq.d c.le.d c.lt.d mov.d movf.d movt.d neg.d sqrt.d"
	eec:		.asciiz "movf.d movt.d"
	eei:		.asciiz "movn.d movz.d"
	eee:		.asciiz "add.d div.d mul.d sub.d"
	ef:		.asciiz "cvt.d.s cvt.d.w"
	es16_i:	.asciiz "ldc1 sdc1"
	fe:		.asciiz "ceil.w.d cvt.w.d cvt.s.d floor.w.d round.w.d trunc.w.d"
	ff_1:		.asciiz "abs.s c.eq.s c.le.s c.lt.s ceil.w.s cvt.s.w cvt.w.s"
	ff_2:		.asciiz "floor.w.s mov.s movf.s movt.s neg.s round.w.s sqrt.s trunc.w.s"
	ffc:		.asciiz "movf.s movt.s"
	fff:		.asciiz "add.s div.s movn.s mul.s sub.s"
	ffi:		.asciiz "movz.s"
	fs16:		.asciiz "lwc1 swc1"
	i:		.asciiz "jalr jr mfhi mflo mthi mtlo"
	i8:		.asciiz "mfc0 mtc0"
	if:		.asciiz "mfc1 mtc1"
	ii:		.asciiz "clo clz div divu jalr madd maddu movf movt msub msubu mult multu teq tge tgeu tlt tltu tne"
	il:		.asciiz "bgez bgezal bgtz blez bltz bltzal"
	iic:		.asciiz "movf movt"
	iii:		.asciiz "add addu and movz movn mul nor or sllv slt sltu srav srlv sub subu xor"
	is16_i:	.asciiz "lb lbu lh lhu ll lw lwl lwr sb sc sh sw swl swr"
	is16:		.asciiz "teqi tgei tgeiu tlti tltiu tnei"
	iu16:		.asciiz "lui"
	iis16:	.asciiz "addi addiu slti sltiu"
	iiu5:		.asciiz "sll sra srl"
	iiu16:	.asciiz "andi ori xori"
	iil:		.asciiz "beq bne"
	l:		.asciiz "bc1f bc1t j jal"
	none:	.asciiz "break eret nop syscall"
	u16:		.asciiz "break"
	
	even_norm_int_reg:		.asciiz "$zero $v0 $a0 $a2 $t0 $t2 $t4 $t6 $s0 $s2 $s4 $s6 $t8 $k0 $gp $fp"
	odd_norm_int_reg:		.asciiz "$at $v1 $a1 $a3 $t1 $t3 $t5 $t7 $s1 $s3 $s5 $s7 $t9 $k1 $sp $ra"
	even_short_int_reg:		.asciiz "$0 $2 $4 $6 $8 $10 $12 $14 $16 $18 $20 $22 $24 $26 $28 $30"
	odd_short_int_reg:		.asciiz "$1 $3 $5 $7 $9 $11 $13 $15 $17 $19 $21 $23 $25 $27 $29 $31"
	even_float_reg:		.asciiz "$f0 $f2 $f4 $f6 $f8 $f10 $f12 $f14 $f16 $f18 $f20 $f22 $f24 $f26 $f28 $f30"
	odd_float_reg:			.asciiz "$f1 $f3 $f5 $f7 $f9 $f11 $f13 $f15 $f17 $f19 $f21 $f23 $f25 $f27 $f29 $f31"
	copro0:				.asciiz "$8 $12 $13 $14 $t0 $t4 $t5 $t6"
	
	three_cycle_1:			.asciiz "bc1f bc1t beq bgez bgezal bgtz blez bltz bltzal bne break eret j jal jalr jr tne tnei"
	three_cycle_2:			.asciiz "mfc0 mfc1 mfhi mflo mov.d mov.s movf movf.d movf.s movn movn.d movn.s tltu"
	three_cycle_3:			.asciiz "mthi mtlo mul mul.d mul.s mult multu neg.d neg.s teq teqi tge tgei tgeiu tgeu tlt tlti tltiu"
	three_cycle_4:			.asciiz "madd maddu msub msubu mtc0 mtc1 movt movt.d movt.s movz movz.d movz.s"
	four_cycle_1:			.asciiz "abs.d abs.s add add.d add.s addi addiu addu and andi c.eq.d c.eq.s c.le.d c.le.s c.lt.d"
	four_cycle_2:			.asciiz "c.lt.s ceil.w.d ceil.w.s clo clz cvt.d.s cvt.d.w cvt.s.d cvt.s.w cvt.w.d cvt.w.s div div.d div.s nop"
	four_cycle_3: 			.asciiz "divu floor.w.d floor.w.s nor or ori round.w.d round.w.s sb sc sdc1 sh sll sllv slt slti sltiu sltu"
	four_cycle_4:			.asciiz "sqrt.d sqrt.s sra srav srl srlv sub sub.d sub.s subu sw swc1 swl swr truncw.d trunc.w.s xor xori"
	five_cycle:			.asciiz "lb lbu ldc1 lh lhu ll lui lw lwc1 lwl lwr"
	undefined_cycle:		.asciiz "syscall"
	
#Return $v0 = 1 if valid, 0 if invalid
.macro valid_ee(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	#check if the first operand is even_float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the second operand is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_eei(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	#check if the first operand is even_float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the second operand is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_eee(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	#check if the first operand is even_float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the second operand is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operad is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_fe(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	la $t3, odd_float_reg
	#check if the first operand is float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_ff(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	la $t3, odd_float_reg
	#check if the first operand is float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_fff(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	la $t3, odd_float_reg
	#check if the first operand is float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_ffi(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	la $t3, odd_float_reg
	#check if the first operand is float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_ffc(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	la $t3, odd_float_reg
	#check if the first operand is float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	move $v0, $t0
	beqz $v0, invalid
	#check if the second operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	move $v0, $t0
	beqz $v0, invalid
	#check if the third operand is cond_flag
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beqz $v1, invalid
	check_int_reg_range($v0, 0, 7)
	beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_ef(%string_of_operands)
	push_reg($t0)
	push_reg($a0)
	push_reg($a1)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $a0, even_float_reg
	la $a1, odd_float_reg
	#check if the first operand is even_float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($a0, $a2)
	beqz $v0, invalid
	#check if the second operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($a0, $a2)
	move $t0, $v0
	check_substring_appearance($a1, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($a1)
		pop_reg($a0)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_i(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_i8(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is coproc0
	la $t2, copro0
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_if(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is float_reg
	la $t2, even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_float_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_ii(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iii(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_none(%string_of_operands)
	push_reg($t0)
	move $t0, %string_of_operands
	#check if operand exists
	get_string_reg_length($t0)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_eec(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	#check if the first operand is even_float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the second operand is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operad is cond_flag
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beqz $v1, invalid
	check_int_reg_range($v0, 0, 7)
	beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_fs16(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	#check if the first operand is float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_float_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_float_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	move $v0, $t0
	beqz $v0, invalid
	#check if the second operand is signed_16_bit_int
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, -32768, 32767)
		beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iic(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	move $v0, $t0
	beqz $v0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	move $v0, $t0
	beqz $v0, invalid
	#check if the third operand is cond_flag
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beqz $v1, invalid
	check_int_reg_range($v0, 0, 7)
	beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_is16(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is signed_16_bit_int
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, -32768, 32767)
		beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iu16(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is unsigned_16_bit_int
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, 0, 65535)
		beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iis16(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is signed_16_bit_int
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, -32768, 32767)
		beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iiu5(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is unsigned_5_bit_int
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, 0, 31)
		beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iiu16(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is unsigned_16_bit_int
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, 0, 65535)
		beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_cee(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	#check if the first operand is cond_flag
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	is_num($a2)
	beqz $v1, invalid
	check_int_reg_range($v0, 0, 7)
	beqz $v0, invalid
	#check if the second operand is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the third operad is even_float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_cff(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($t3)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	la $t3, odd_float_reg
	#check if the first operand is cond_flag
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	is_num($a2)
	beqz $v1, invalid
	check_int_reg_range($v0, 0, 7)
	beqz $v0, invalid
	#check if the second operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is float_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	check_substring_appearance($t3, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t3)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_u16(%string_of_operands)
	push_reg($t0)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	#check if the first operand is unsigned_16_bit_int
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, 0, 65535)
		beqz $v0, invalid
	#check if the second operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_es16_i(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	#check if the first operand is even_float_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_float_reg
	check_substring_appearance($t2, $a2)
	beqz $v0, invalid
	#check if the second operand is signed_16_bit_int(int_reg) Ex: -100($t1)
	#check offset
	trim_space_reg($a3)
	split_by_literal_separator($a3, '(')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, -32768, 32767)
		beqz $v0, invalid
	#check register
	trim_space_reg($a3)
	split_by_literal_separator($a3, ')')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_is16_i(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is signed_16_bit_int(int_reg) Ex: -100($t1)
	#check offset
	trim_space_reg($a3)
	split_by_literal_separator($a3, '(')
	trim_space_reg($a2)
	is_num($a2)
	beq $v1, 1, check_num
	is_hexa($a2)
	beq $v1, 1, check_num
	j invalid
	check_num:
		check_int_reg_range($v0, -32768, 32767)
		beqz $v0, invalid
	#check register
	trim_space_reg($a3)
	split_by_literal_separator($a3, ')')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_il(%string_of_operands)
	push_reg($t0)
	push_reg($t2)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	la $t2, even_norm_int_reg
	check_substring_appearance($t2, $a2)
	move $t0, $v0
	la $t2, odd_norm_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, even_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	la $t2, odd_short_int_reg
	check_substring_appearance($t2, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is a valid label
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_label($a2)
	beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_iil(%string_of_operands)
	push_reg($t0)
	push_reg($t4)
	push_reg($t5)
	push_reg($t6)
	push_reg($t7)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	la $t4, even_norm_int_reg
	la $t5, odd_norm_int_reg
	la $t6, even_short_int_reg
	la $t7, odd_short_int_reg
	#check if the first operand is int_reg
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the second operand is int_reg
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_substring_appearance($t4, $a2)
	move $t0, $v0
	check_substring_appearance($t5, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t6, $a2)
	add $t0, $t0, $v0
	check_substring_appearance($t7, $a2)
	add $t0, $t0, $v0
	beqz $t0, invalid
	#check if the third operand is a valid label
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_label($a2)
	beqz $v0, invalid
	#check if the fourth operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t7)
		pop_reg($t6)
		pop_reg($t5)
		pop_reg($t4)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_cl(%string_of_operands)
	push_reg($t0)
	push_reg($a2)
	push_reg($a3)
	push_reg($v1)
	move $t0, %string_of_operands
	la $t2, even_float_reg
	#check if the first operand is cond_flag
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	is_num($a2)
	beqz $v1, invalid
	check_int_reg_range($v0, 0, 7)
	beqz $v0, invalid
	#check if the second operand is a valid label
	trim_space_reg($a3)
	split_by_literal_separator($a3, ',')
	trim_space_reg($a2)
	check_label($a2)
	beqz $v0, invalid
	#check if the third operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($v1)
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t0)
.end_macro

#Return $v0 = 1 if valid, 0 if invalid
.macro valid_l(%string_of_operands)
	push_reg($t0)
	push_reg($a2)
	push_reg($a3)
	move $t0, %string_of_operands
	#check if the first operand is a valid label
	trim_space_reg($t0)
	split_by_literal_separator($t0, ',')
	trim_space_reg($a2)
	check_label($a2)
	beqz $v0, invalid
	#check if the second operand exists
	get_string_reg_length($a3)
	bnez $v0, invalid
	addi $v0, $zero, 1
	j done
	invalid:
		addi $v0, $zero, 0
	done:
		pop_reg($a3)
		pop_reg($a2)
		pop_reg($t0)
.end_macro
