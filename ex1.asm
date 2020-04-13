.data 0x0

animal:  .space	 300      # animal array that can hold 20 animals that are no more than 15 characters
lyric:   .space	 1200     # lyric array that can  hold 20 lines that are no more than 60 characters
oldLady: 	 .asciiz	  "There was an old lady who swallowed a " 
she:	 .asciiz	  "She swallowed the "
toCatch:   .asciiz	  " to catch the "
semicolon:	 .asciiz	  ";"
idk:     .asciiz          "I don't know why she swallowed a "
dash:    .asciiz 	  " - "
space:	 .asciiz	  " "
end:	 .asciiz	  "END\n"
newline: .asciiz          "\n"
terminate: .asciiz       	  "\0"

.text 0x3000

main:
	addi $s0, $0, 0		#set s0 to 0 to act at counter
	addi $s1, $0, 40	#set s1 to 40 (20 lines and 20 animals)
	addi $s2, $0, 0		#animal counter
	addi $s3, $0, 0		#lyric counter
	addi $s4, $0, 0		#counter for nurseryrhyme loop
	addi $s5, $0, 2		#for divide by 2 to be used later
	addi $s6, $0, 0		#counter for nurseryrhyme loop
	addi $s7, $0, 0		#counter for space
	
	addi $t4, $0, 15	#15
	addi $t5, $0, 60	#60
			
iterate:
  	beq $s0, $s1, divideBy2
  	li $v0, 8
  	la $a0, animal($s2)	#store section save2 into animal array
  	li $a1, 15
  	syscall

  	addi $t1, $0, 0		#counter for compare loop for END
  	addi $t2, $s2, 0	#counter for compare loop for animal
  	addi $3, $s2, 0		#for eat loop
  	addi $t3, $0, 4		#4 for compare loop
  
   endToPrint: 			#see if the answer is END here and jump to print if it is
   	beq $t1, $t3, divideBy2	
   	lb $t6, end($t1)
   	lb $t7, animal($t2)
   	bne $t6, $t7, ate
   	addi $t1, $t1, 1	#increment t1 by 1
   	addi $t2, $t2, 1	#increment t2 by 1
   	j endToPrint
   	
  ate:
   	lb $1, newline($0)
   	lb $2, animal($3)
   	beq $1, $2, null
   	addi $3, $3, 1
   	j ate
   
  null:
  	lb $1, terminate($0)
  	sb $1, animal($3)
   
  continue:
 	addi $s2, $s2, 15	#increment s2 by 15
  	addi $s0, $s0, 1	#increment s0 by 1
 
  
  	la $a0, lyric($s3)
  	li $a1, 60
  	li $v0, 8
  	syscall
  
  	addi $s3, $s3, 60	#increment s3 by 60
  	addi $s0, $s0, 1	#increment s0 by 1
  
 	j iterate
 
divideBy2:
	div $s0, $s5		#find number of pairs
	mflo $s0		#store in s0
	addi $s6, $s0, -1	#store number of pairs - 1 in s6  
 
    
nurseryrhyme:
  	beq $s0, $s4, nr	#if counter = number of pairs, break
  	mult $s4, $t4
  	mflo $t0		#current for animal (I*15)
  	mult $s4, $t5
  	mflo $t1		#current for lyric (i*60)
    
    	addi $s7, $0, 0		#counter for space
    spaces:
 	beq $s7, $s4, cont
     	addi $v0, $0, 4  	# system call 4 is for printing a string
  	la $a0, space 		# address of space string is in $a0
  	syscall               	# print the string
    	addi $s7, $s7, 1	#increment s4 by 1
    	j spaces

cont:
  	beq $t0, $0, zero	#if current ==0, print "there was an.."
 	addi $t2, $t0, -15	#current animal - 1
  	addi $t3, $t0, -60	#current lyric - 1
  
  	li $v0, 4
  	la $a0, she		#"She swallowed the "
  	syscall
  
  	li $v0, 4
  	la $a0, animal($t2) 	#current - 1
  	syscall
  
  	li $v0, 4
  	la $a0, toCatch		 #" to catch the "
  	syscall
  
  	li $v0, 4
  	la $a0, animal($t0)	#current
  	syscall
  
  	li $v0, 4
   	la $a0, semicolon
   	syscall
  
  	li $v0, 4
  	la $a0, newline
  	syscall
  
  
  	addi $s4, $s4, 1	#increment counter by 1
  	j nurseryrhyme
  

zero:
   	li $v0, 4
   	la $a0, oldLady
   	syscall
   
   	li $v0, 4
   	la $a0, animal($t0)
   	syscall
   
   	li $v0, 4
   	la $a0, semicolon
   	syscall
    	
   	li $v0, 4
  	la $a0, newline
   	syscall
   
   
  	addi $s4, $s4, 1	#increment counter by 1
   	j nurseryrhyme

nr: 
 	bltz $s6, exit
  	mult $s6, $t4
  	mflo $t0		#current for animal (I*15)
  	mult $s6, $t5
  	mflo $t1		#current for lyric (i*60)
  	addi $s7, $0, 0		#counter for space
  
  
    spaces2:
 	beq $s7, $s6, nrc
     	addi $v0, $0, 4  	# system call 4 is for printing a string
  	la $a0, space 		# address of space string is in $a0
  	syscall               	# print the string
    	addi $s7, $s7, 1	#increment s4 by 1
    	j spaces2
 	   	
nrc:
	li $v0, 4
   	la $a0, idk
   	syscall
   
   	li $v0, 4
   	la $a0, animal($t0)
   	syscall
   
   	li $v0, 4
   	la $a0, dash
   	syscall
   
   	li $v0, 4
   	la $a0, lyric($t1)
   	syscall
    
   	addi $s6, $s6, -1
   	j nr
    	  
exit:
  	addi $v0, $0, 10
  	syscall      	
			
