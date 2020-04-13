.data
newline: .asciiz	"\n"
maze: .space 100	# int maze[100][100];
wasHere: .space 100	# int wasHere[100][100];
correctPath: .space 100	# int correctPath[100][100];
startX: .space 4	# int startX;
startY: .space 4	# int startY;
endX: .space 4		# int endX;
endY: .space 4		# int endY;
        
.text 0x3000

main:
	ori $sp, $0, 0x3000
	addi $fp, $sp, -4       # Set $fp to the start of main's stack frame
	
	addi $t0, $t0, 0
	addi $t1, $t1, 0
	
	li $v0, 5		# syscall to read integer
	syscall			# read width
	move $a0, $v0		# store width to $a0 
	
	li $v0, 5		# syscall to read integer
	syscall			# read height
	move $a1, $v0		# store height to $a0 
	
	addi $v0, $0, 4		# system call 4 is for printing a string
  	la $a2, newline 	# address of newLine is in $a0
  	syscall
  	
heightLoop:
	bge $t1, $a1, recursive_solve	# if y is greater than/equal to height, branch to recursive_solve
	j widthLoop			# otherwise, jump to widthLoop
	li $v0, 12			# syscall to read character
	syscall				# read tempchar
	move $a3, $v0			# store tempchar value to $a3
	addi $t1, $t1, 1		# upon return, y++
	j heightLoop			# loop to beginning

widthLoop:
	bge $t0, $a0, heightLoop
	li $v0, 12		# syscall to read character
	syscall			# read tempchar
	move $a3, $v0		# store tempchar value to $a3

resursiveSolve:
	
  	
end: 
	ori $v0, $0, 10     	# system call 10 for exit
	syscall              	# we are out of here.
