#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        12_vec_cmpltu.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      Each element of the result D is true (all bits = 1) if the corresponding
#		    element of vector A is less than the corresponding element of vector B. 
#		    Otherwise the element of result is FALSE (all bit = 0)
#		    
# Register usage:   
#		    $t0: Upper 32 bits of vector a
#		    $t1: Lower 32 bits of vector a
#		    $t2: Upper 32 bits of vector b
#		    $t3: Lower 32 bits of vector b
#		    $s0: Upper 32 bits of vector d
#		    $s1: Lower 32 bits of vector d
#
#		    $t6: Result from comparing current elements of vectors a and b
#		    $t8: Masks for one byte allowing us to access a vector element
#		    $v1: Boolean to check Lower or Upper bits
#		    $v1: Counter for vector elements
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                        # main (must be global)
           .globl main

main:		#Initializations
  
		# Setting testing values
           	addi $t0, $zero, 0x5AFB6C1D			
     	   	addi $t1, $zero, 0xA65FC040
     	   	addi $t2, $zero, 0x52FBA415			
     	   	addi $t3, $zero, 0xAE5FC841
     	   	addi $v1, $zero, 0		# Counter
     	   	addi $t6, $zero, 0		# Use to access 8 bits
		addi $t8, $zero, 0xFF000000	# Use to access 8 bits			
     	   
     	   	# Clear storage registers
     	  	addi $s0, $zero, 0	
     	  	addi $s1, $zero, 0	

loop:
		beq $v1, 8, exit		# We are done
		
		slti $v0, $v1, 4
		beq $v0, $zero, lower32

		# Upper 32 bits 		
		and $t4, $t0, $t8		# Get 8 bits from upper vector A
		and $t5, $t2, $t8		# Get 8 bits from upper vector B

		j continue	
				
lower32:	# Lower 32 bits 

		bne $v1, 4, skipReset		# are we in v[4]? 
		addi $t8, $zero, 0xFF000000	# --> Reset mask
		addi $s1, $zero, 0		# Clear upper register
skipReset:	
		and $t4, $t1, $t8		# Get 8 bits from lower vector A
		and $t5, $t3, $t8		# Get 8 bits from lower vector B

continue:	
		addi $t6, $zero, 0		# Nothing to add
	  	slt $t7, $t4, $t5		# Compare a[i] vs b[i]
	  	bne $t7, $zero, less		
	  	j noless
less:
	  	add $t6, $t6, $t8		# Put result in a temp register
noless:
		# Saving registers
		slti $v0, $v1, 4
		beq $v0, $zero, saveLower32
		add $s0, $s0, $t6		# Store in upper 32 of vector D  
saveLower32:	
		add $s1, $s1, $t6		# Store in upper 32 of vector D
			
	  	srl $t8, $t8, 8			# Shift 1 byte for next element
	  	addi $v1, $v1, 1		# Increment counter
	  	j loop		
	  	
		#-------------------------------------------------------------
		# "Due diligence" to return control to the kernel
		#--------------------------------------------------------------
exit:		ori        $v0, $zero, 10     # $v0 <-- function code for "exit"
		syscall                       # Syscall to exit


		#*************************************************************
		#  P R O J E C T    R E L A T E D    S U B R O U T I N E S
		#*************************************************************
proc1:		j         proc1               # "placeholder" stub

