.data
Infix: .space 256
Postfix: .space 256
Operator: .space 256
Result: .space 256

errorMsg: .asciiz "Input error"
errorResultMsg: .asciiz "Result error (divisor is equal to 0)"
startMsg: .asciiz "Enter infix expression\nNote: only allowed to use + - * / ()\nNumber from 00-99"
prompt_infix: .asciiz "Infix expression: "
prompt_postfix: .asciiz "Postfix expression: "
prompt_result: .asciiz "Result: "
prompt_confirm: .asciiz "Do you want to continue?"

.text
main:
# Get infix expression
	li $v0, 54
	la $a0, startMsg
	la $a1, Infix
 	la $a2, 256
 	syscall
 	
 	bnez $a1, errorInput
 	
# Print infix 
	li $v0, 4
	la $a0, prompt_infix
	syscall
	li $v0, 4
	la $a0, Infix
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
#-----------------------------------------------------------------------------------
# s5 is the code of precedence of the checking-operand
# s6 is the code of precedence of the top operand
# 	'+', '-' is 1
# 	'*', '/' is 2
# s7 is the digit of operand (1 or 2)
# t0, t1, t2 are indexes
# t4 is status code to check error input
#	0 means that previous scan is operator except '(' and ')'
#	1 means that previous scan is operand
# t5 stores scanning character in Infix string and Postfix stack
# t6 stores operator loaded from Operator stack
# t7 stores address holding character in Infix string or Postfix stack
# t8 stores address holding top operand or operator in Postfix stack
# t9 stores address holding top operand in Operator stack
#-----------------------------------------------------------------------------------
init:	
	la $s0, Infix
	la $s1, Postfix
	la $s2, Operator
	sw $zero, 0($s2)
	sw $zero, 4($s2)
	addi $t9, $s2, -1
	li $t0, -1
	li $t1, -1
	li $t2, -1
	li $s3, 0
	li $s4, 0
	li $t3, 0
	li $t4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	
	j scanInfix
endMain:
	# Confirm continue or exit
	li $v0, 50
	la $a0, prompt_confirm
	syscall
	beq $a0, 0, main
	# Exit program
	li $v0, 10
	syscall
	
scanInfix:
	addi $t0, $t0, 1
	add $t7, $s0, $t0
	lbu $t5, 0($t7)
	beq $t5, ' ', scanInfix
	j isDigit
	continueScan:
	j isOperator
	loop3:
		lw $a0, 0($s2)
		beqz $a0, endScanInfix
		lbu $t6, 0($t9)
		addi $t6, $t6, -100
		beq $t6, '(', errorInput
		move $s3, $t6
		addi $s3, $s3, 100
		sb $zero, 0($t9)
		addi $t9, $t9, -1
		j pushPostfix
	j scanInfix
endScanInfix:
	j printPostfix

printPostfix:
	li $v0, 4
	la $a0, prompt_postfix
	syscall
	li $t1, -1
	beqz $t8, errorInput
	addi $t8, $t8, 1
	li $t4, '\n'
	addi $t4, $t4, 100			# Encode '\n'
	sb $t4, 0($t8)
	while:
	addi $t1, $t1, 1
	add $t7, $s1, $t1
	lbu $t5, 0($t7)
	addi $t5, $t5, -100			# Decode character
	beq $t5, '\n', calculateResult
	# Print
	addi $t5, $t5, 100			# Return value of operator or number
	bgt $t5, 99, printOp
	li $v0, 1
	move $a0, $t5
	syscall
	j printSpace
	printOp:
	li $v0, 11
	addi $t5, $t5, -100			# Decode operator
	move $a0, $t5
	syscall	
	printSpace:
	li $v0, 11
	li $a0, ' '
	syscall
	j while

printResult:
	li $v0, 11
	li $a0, '\n'
	syscall
	li $v0, 4
	la $a0, prompt_result
	syscall
	li $v0, 1
	lw $a0, 0($s2)
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	j endMain
	
calculateResult:
	la $s2, Result
	addi $s1, $s1, -1
	addi $s2, $s2, -4
	for:
	addi $s1, $s1, 1
	lbu $t5, 0($s1)
	addi $t5, $t5, -100
	beq $t5, '\n', printResult
	addi $t5, $t5, 100
	bgt $t5, 99, doOp
	j pushResult
	
pushResult:
	addi $s2, $s2, 4
	sw $t5, 0($s2)
	j for

popResult:
	lw $s4, 0($s2)
	addi $s2, $s2, -4
	lw $s3, 0($s2)
	addi $s2, $s2, -4
	jr $ra
	
#----------------------------------
# s3 is the 1st operand
# s4 is the 2nd operand
# t5 is the result of s3 op s4
#----------------------------------
doOp:	
	jal popResult
	addi $t5, $t5, -100
	beq $t5, '+', doAdd
	beq $t5, '-', doSub
	beq $t5, '*', doMul
	beq $t5, '/', doDiv
	j for
doAdd:
	add $t5, $s3, $s4
	j pushResult
doSub:
	sub $t5, $s3, $s4
	j pushResult
doMul:
	mul $t5, $s3, $s4
	j pushResult
doDiv:
	beqz $s4, errorResult
	div $t5, $s3, $s4
	j pushResult
		
isDigit:
	beq $t5, '0', storeOperand
	beq $t5, '1', storeOperand
	beq $t5, '2', storeOperand
	beq $t5, '3', storeOperand
	beq $t5, '4', storeOperand
	beq $t5, '5', storeOperand
	beq $t5, '6', storeOperand
	beq $t5, '7', storeOperand
	beq $t5, '8', storeOperand
	beq $t5, '9', storeOperand
	
	beq $s7, 0, isOperator
	addi $t4, $zero, 1
	beq $s7, 1, pushPostfix
	mul $s3, $s3, 10
	add $s3, $s3, $s4
	j pushPostfix

storeOperand:
	beq $t4, 1, errorInput	
	beq $s7, 0, storeDigit1
	beq $s7, 1, storeDigit2
	beq $s7, 2, errorInput
	
storeDigit1:
	addi $s3, $t5, -48
	addi $s7, $s7, 1
	j scanInfix
storeDigit2:
	addi $s4, $t5, -48
	addi $s7, $s7, 1
	j scanInfix
	
# Push to Postfix
# s3 store character to push to Postfix
pushPostfix:
	addi $t1, $t1, 1
	add $t8, $s1, $t1
	sb $s3, 0($t8)
	move $s7, $zero
	beq $t5, ')', loop1
	bnez $s5, loop2
	beq $t5, '\n', loop3
	j continueScan

pushOperator:
	addi $t9, $t9, 1
	addi $t5, $t5, 100			# Encode operator
	sb $t5, 0($t9)
	move $t4, $zero
	j scanInfix
	
checkOperatorStack:
	beqz $t4, errorInput 
	loop1:
		lw $a0, 0($s2)			# Load operator stack
		beqz $a0, errorInput		# Check operator stack is empty or not
		lbu $t6, 0($t9)			# Load top operator stack
		addi $t6, $t6, -100		# Encode operator
		beq $t6, '(', endLoop1		# Check if top operator stack is '(' or not
		sb $zero, 0($t9)		# If not, pop operator stack
		move $s3, $t6			
		addi $s3, $s3, 100
		addi $t9, $t9, -1
		j pushPostfix
		j loop1		
	endLoop1:
	sb $zero, 0($t9)
	addi $t9, $t9, -1
	j scanInfix
		
isOperator:
	beq $t5, '\n', loop3
	bne $t5, '(', skipThis
	beq $t4, 1, errorInput
	j pushOperator
	skipThis:
	beq $t5, ')', checkOperatorStack
	
	beq $t4, 0, errorInput
	#normalOperator
	beq $t5, '+', keepOn
	beq $t5, '-', keepOn
	beq $t5, '*', keepOn
	beq $t5, '/', keepOn
	j errorInput				# If receive other character, error input
	
	keepOn:
	lw $a0, 0($s2)
	beqz $a0, pushOperator
	lbu $t6, 0($t9)
	addi $t6, $t6, -100
	beq $t6, '(', pushOperator
	#else
	loop2:
		lw $a0, 0($s2) 
		beqz $a0, endLoop2
		lbu $t6, 0($t9)
		addi $t6, $t6, -100
		beq $t6, '(', endLoop2
			
		j setOp
		continue:
		
		bgt $s5, $s6, endLoop2
		sb $zero, 0($t9)
		addi $t9, $t9, -1
		move $s3, $t6
		addi $s3, $s3, 100
		j pushPostfix
	endLoop2:
	move $s5, $zero
	j pushOperator

setOp:
	beq $t5, '+', lowerSign1
	beq $t5, '-', lowerSign1
	addi $s5, $zero, 2	
	j continue1
	lowerSign1:
	addi $s5, $zero, 1
	j continue1
	
	continue1:
	
	beq $t6, '+', lowerSign2
	beq $t6, '-', lowerSign2
	addi $s6, $zero, 2	
	j continue
	lowerSign2:
	addi $s6, $zero, 1
	j continue

errorInput:
	li $v0, 55
 	la $a0, errorMsg
 	li $a1, 2
 	syscall
 	j endMain
 
errorResult:
	li $v0, 55
 	la $a0, errorResultMsg
 	li $a1, 2
 	syscall
 	j endMain
	
	
		
	
