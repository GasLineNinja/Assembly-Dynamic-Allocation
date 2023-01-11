###########################################################
#	Name: Michael Strand
#	Date: 4/30/21

###########################################################
#		Program Description
#	Data Structure: [itemName (16 byte string), itemPrice (single), itemCount (integer)]
#
#	The program dynamically allocates an array of data structures and
#	asks the user for input to fill it. 
#
#	The data structure will print to the console and do the following:
#		->Calculate the sum and average of all items
#		->Find the items that have the min value and max value
#		->Finally, main will print out the sum, average, and information
#			(name, price, count) of the min and max item values

###########################################################
#		Register Usage
#	$t0	array base address
#	$t1	array length
#	$t2	min address
#	$t3	max address
#	$t4
#	$t5
#	$t6
#	
#	$f12	sum
#	$f13	average
###########################################################
		.data
print_name_p:	.asciiz	"Name: "
print_price_p:	.asciiz	"Price: "
print_count_p:	.asciiz	"Count: "
min_item_p:		.asciiz	"\nMinimum Value Item: "
max_item_p:		.asciiz	"\nMaximum Value Item: "
###########################################################
		.text
main:
	#allocate_structure stack set up
	addi $sp, $sp, -12
	sw $ra, 8($sp)

	jal allocate_array

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	#read_structure stack setup
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 8($sp)

	jal read_structure

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	#print_structure stack setup
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 8($sp)

	jal print_structure

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	#sum_average stack setup
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 16($sp)
	
	jal sum_average

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	l.s $f12 8($sp)
	l.s $f13 12($sp)
	lw $ra, 16($sp)

	#get_min_max stack setup
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 16($sp)

	jal get_min_max

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $ra, 16($sp)#

	#print min
	li $v0, 4						#print "Minimum Item Value:"
	la $a0, min_item_p
	syscall

	li $v0, 11
	li $a0, 10
	syscall


	li $v0, 4						#print "Name:"
	la $a0, print_name_p
	syscall

	li $v0, 4						#print item name
	move $a0, $t2
	syscall

	li $v0, 11						#print tab
	li $a0, 9
	syscall

	li $v0, 4						#print "Price:"
	la $a0, print_price_p
	syscall

	li $v0, 2						#print itme price
	l.s $f12, 16($t2)
	syscall

	li $v0, 11						#print tab
	li $a0, 9
	syscall

	li $v0, 4						#print "Count:"
	la $a0, print_count_p
	syscall

	li $v0, 1						#print item count
	lw $a0, 20($t2)
	syscall

	li $v0, 11						#print new line
	li $a0, 10
	syscall

	#print max
	li $v0, 4						#print "Maximum Item Value:"
	la $a0, max_item_p
	syscall

	li $v0, 11
	li $a0, 10
	syscall


	li $v0, 4						#print "Name:"
	la $a0, print_name_p
	syscall

	li $v0, 4						#print item name
	move $a0, $t3
	syscall

	li $v0, 11						#print tab
	li $a0, 9
	syscall

	li $v0, 4						#print "Price:"
	la $a0, print_price_p
	syscall

	li $v0, 2						#print itme price
	l.s $f12, 16($t3)
	syscall

	li $v0, 11						#print tab
	li $a0, 9
	syscall

	li $v0, 4						#print "Count:"
	la $a0, print_count_p
	syscall

	li $v0, 1						#print item count
	lw $a0, 20($t3)
	syscall


	li $v0, 10		#End Program
	syscall
###########################################################

###########################################################
#		allocate_structure Subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp+0	array base address(OUT)
#	$sp+4	array lenght(OUT)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0	base address
#	$t1	array length
#	$t2 24
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
allocate_length_prompt:	.asciiz	"Enter an array length > 0. "
allocate_invalid_prompt:	.asciiz	"Invalid input. "
###########################################################
		.text
allocate_array:
	allocate_loop:
		li $v0, 4						#ask for length
		la $a0, allocate_length_prompt
		syscall

		li $v0, 5						#read integer
		syscall

		blez $v0, invalid_input			#make sure length > 0
		move $t1, $v0

		li $t2, 24						#$t2 = 24

		li $v0, 9						#create array 
		mul $a0, $t1, $t2
		syscall

		move $t0, $v0

		b allocate_end

	invalid_input:
		li $v0, 4
		la $a0, allocate_invalid_prompt
		syscall

		b allocate_loop

allocate_end:
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		read_structure Subprogram
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp+0	array base address(IN)
#	$sp+4	array length(IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
read_name_prompt:	.asciiz	"Enter the item name. "
read_price_prompt:	.asciiz	"Enter the item price. "
read_count_prompt:	.asciiz	"Enter the number of items. "
read_invalid_price:	.asciiz	"Invalid price. "
read_invalid_count:	.asciiz	"Invalid number of items. "
###########################################################
		.text
read_structure:
	li.s $f1, 0.0						#$f1 = 0

	fill_array_loop:
		blez $t1, read_end			#array count
		li $v0, 4					#get name prompt
		la $a0, read_name_prompt
		syscall

		li $v0, 8					#read string
		move $a0, $t0
		li $a1, 16
		syscall

	price_loop:
		li $v0, 4					#get price prompt
		la $a0, read_price_prompt
		syscall

		li $v0, 6					#read single
		syscall

		c.le.s $f0, $f1				#make sure price is > 0
		bc1t invalid_price
		
		s.s $f0, 16($t0)			#store price

		b count_loop

	invalid_price:
		li $v0, 4					#invalid price prompt
		la $a0, read_invalid_price
		syscall

		b price_loop

	count_loop:
		li $v0, 4					#get count prompt
		la $a0, read_count_prompt
		syscall

		li $v0, 5					#read integer
		syscall

		blez $v0, invalid_count		#make sure count is > 0

		sw $v0, 20($t0)				#store count

		addi $t0, $t0, 24			#increment index by 24
		addi $t1, $t1, -1			#decrement count

		b fill_array_loop

	invalid_count:
		li $v0, 4					#invalid count prompt
		la $a0, read_invalid_count
		syscall

		b count_loop

read_end:
	jr $ra	#return to calling location
###########################################################

###########################################################
#		print_structure Subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp+0	array base address(IN)
#	$sp+4	array length(IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0	base address
#	$t1	array length
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
print_name:		.asciiz	"Name: "
print_price:	.asciiz	"Price: "
print_count:	.asciiz	"Count: "
item_list:		.asciiz	"\nItem List:\n"
###########################################################
		.text
print_structure:
	lw $t0, 0($sp)
	lw $t1, 4($sp)

	li $v0, 4
	la $a0, item_list
	syscall

	print_loop:
		blez $t1, print_end				#counter

		li $v0, 4						#print "Name:"
		la $a0, print_name
		syscall

		li $v0, 4						#print item name
		move $a0, $t0
		syscall

		li $v0, 11						#print tab
		li $a0, 9
		syscall

		li $v0, 4						#print "Price:"
		la $a0, print_price
		syscall

		li $v0, 2						#print itme price
		l.s $f12, 16($t0)
		syscall

		li $v0, 11						#print tab
		li $a0, 9
		syscall

		li $v0, 4						#print "Count:"
		la $a0, print_count
		syscall

		li $v0, 1						#print item count
		lw $a0, 20($t0)
		syscall

		li $v0, 11						#print new line
		li $a0, 10
		syscall

		addi $t0, $t0, 24				#increment index by 24
		addi $t1, $t1, -1				#decrement count

		b print_loop

print_end:
	jr $ra	#return to calling location
###########################################################

###########################################################
#		sum_average Subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp+0	array base address(IN)
#	$sp+4	array length(IN)
#	$sp+8	sum of all items(single precision)(OUT)
#	$sp+12	average of all items(single precision)(OUT)	
###########################################################
#		Register Usage
#	$t0	base address
#	$t1	array length
#	$t2 count temp
#
#	$f0	sum
#	$f1	average
#	$f2	price temp
#	$f3	count in single
#	$f4	number of items in single
###########################################################
		.data

###########################################################
		.text
sum_average:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	li.s $f0, 0.0

	mtc1 $t1, $f4				#converting number of items to single
	cvt.s.w $f4, $f4

	sum_loop:
		blez $t1, sum_end
		
		l.s $f2, 16($t0)		#price into $f2
		lw $t2, 20($t0)			#count into $t2

		mtc1 $t2, $f3			#converting the count to single
		cvt.s.w $f3, $f3

		mul.s $f2, $f2, $f3		#price x count
		add.s $f0, $f0, $f2		#sum of Price

		addi $t0, $t0, 24
		addi $t1, $t1, -1

		b sum_loop

sum_end:
	div.s $f1, $f0, $f4			#price / number of items

	l.s $f0, 8($sp)
	l.s $f1, 12($sp)

	jr $ra	#return to calling location
###########################################################

###########################################################
#		get_min_max Subprogram

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp+0	array base address(IN)
#	$sp+4	array length(IN)
#	$sp+8	address of min value(OUT)
#	$sp+12	address of max value(OUT)
###########################################################
#		Register Usage
#	$t0	array base address
#	$t1	array length
#	$t2	min address
#	$t3	max address
#	$t4	count temp
#	$t5
#
#	$f0	price
#	$f1	count in single
#	$f2	min/max 
#	$f3	temp
###########################################################
		.data

###########################################################
		.text
get_min_max:
	lw $t0, 0($sp)
	lw $t1, 4($sp)

	l.s $f0, 16($t0)				#price into $f0
	li.s $f2, 0.0

	lw $t4, 20($t0)
	mtc1 $t4, $f1
	cvt.s.w $f1, $f1

	mul.s $f2, $f0, $f1

	move $t2, $t0					#min so far address
	
	min_loop:
		addi $t0, $t0, 24
		addi $t1, $t1, -1

		blez $t1, min_end

		l.s $f0, 16($t0)			#min so far price into $f0
		lw $t4, 20($t0)

		mtc1 $t4, $f1				#convert count to single
		cvt.s.w $f1, $f1

		mul.s $f3, $f0, $f1

		c.lt.s $f3, $f2				#comparing if $f3 < $f2
		bc1t min_value

		b min_loop

	min_value:
		move $t2, $t0

		b min_loop

	min_end:
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		l.s $f0, 16($t0)			#max so far price into $f0
		li.s $f2, 0.0

		lw $t4, 20($t0)
		mtc1 $t4, $f1
		cvt.s.w $f1, $f1

		mul.s $f2, $f0, $f1

		move $t3, $t0				#max so far address

	max_loop:
		addi $t0, $t0, 24
		addi $t1, $t1, -1

		blez $t1, min_max_end

		l.s $f0, 16($t0)			#price into $f0
		lw $t4, 20($t0)

		mtc1 $t4, $f1				#convert count to single
		cvt.s.w $f1, $f1

		mul.s $f3, $f0, $f1

		c.lt.s $f3, $f2
		bc1f max_value

		b max_loop

	max_value:
		move $t3, $t0	
		
		b max_loop
		
min_max_end:
	sw $t2, 8($sp)
	sw $t3, 12($sp)

	jr $ra	#return to calling location
###########################################################

