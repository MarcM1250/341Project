#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        10_vec_perm.asm
# Version:          1.0
# Date:             December 03, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:
#		    ver_perm uses vector C as a sophisticated mask and assigns corresponding
#		    values of the operands A and B to the D vector. For example, element[i]
#		    of A or B is mapped to element [j] of the vector D. Each "element specifier"
# 		    in vector C has two componentes: the most-significant-half specifies an
#		    element from either vector A or B (0 = A, 1 = B)
#		    The least-significan-half specifies which element within the selected
#		    vector [0..7]
#
# Register usage:   
#		    $s0: Upper 32 bits of vector d
#		    $s1: Lower 32 bits of vector d
#
#		    $s5: Most significant half of element from vector C
#		    $s6: Least significant half of element from vector C
#
#		    $t0: Upper 32 bits of vector a
#		    $t1: Lower 32 bits of vector a
#		    $t2: Upper 32 bits of vector b
#		    $t3: Lower 32 bits of vector b
#		    $t4: Upper 32 bits of vector c
#		    $t5: Lower 32 bits of vector c
#		      
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                       		# main (must be global)
           .globl main

main:      #Initializations

           # Setting testing values
           addi $t0, $zero, 0xA567013D		# Vector A		
           addi $t1, $zero, 0xAB45393C
           addi $t2, $zero, 0xEFC54D23		# Vector B		
           addi $t3, $zero, 0x1277AACD			
           addi $t4, $zero, 0x04171002		# Vector C		
           addi $t5, $zero, 0x13050105     	   	    	   
     	  	
           addi $s5, $zero, 0xF0000000		# Mask to get 4 bits most-significant-half
           addi $s7, $zero, 0x0F000000		# Mask to get 4 bits least-significant-half
     	  		
	   # Initialize array pointers

           la $s2, vectorA			# Set $s2 to point at label "vectorA"
           la $s3, vectorB			# Set $s3 to point at label "vectorB"
           la $s4, vectorD			# Set $s4 to point at label "vectorC"   	 
	
	   # Put register data from $t0 and $t1 into vector a array
	   # (Each byte is an element)
	   
           addi $t7, $zero, 0xFF000000		# Set to access leftmost element in $t0
           addi $t9, $zero, 24			# Shift length
           
     	   # Move $t0 into vector a array	
set1:	   and $v0, $t0, $t7			# Get one byte
           srlv $v0, $v0, $t9			# Shift element all the way to the right
           sw $v0, 0($s2)			# Store element into vector A array
           addi $s2, $s2, 4			# Move to next index of array
           srl $t7, $t7, 8			# Access next element in register $t0
           addi $t9, $t9, -8 			# Decrement shift amount by 8
           bne $t9, -8, set1			# Loop back
	   	
           addi $t7, $zero, 0xFF000000		# Reset mask 
           addi $t9, $zero, 24			# Set shift amount
           
	   # Move $t1 into vector a array	
set2:	   and $v0, $t1, $t7			# Get element
	   srlv $v0, $v0, $t9			# Shift element all the way to the right
           sw $v0, 0($s2)			# Store element into vector A array
           addi $s2, $s2, 4			# Move to next index of array
           srl $t7, $t7, 8			# Access next element in $t1
           addi $t9, $t9, -8 			# Decrement shift by 8
           bne $t9, -8, set2			# Loop back
	   	
           subi $s2, $s2, 32			# Reset to point at "vectorA"
	   	
	   # Put register data from $t2 and $t3 into vector B array
	   
           addi $t7, $zero, 0xFF000000		# Reset shift for leftmost in $t2
           addi $t9, $zero, 24			# Reset shift length
           
           #Move $t2 into vector b array		   	
set3:	   	
           and $v0, $t2, $t7			# Get element
           srlv $v0, $v0, $t9			# Shift element all the way to the right
           sw $v0, 0($s3)			# Store element into vector B array
           addi $s3, $s3, 4			# Move to next index of array
           srl $t7, $t7, 8			# Access next element in $t2
           addi $t9, $t9, -8 			# Decrement shift by 8
           bne $t9, -8, set3			# Loop back
	   	
           addi $t7, $zero, 0xFF000000		# Reset to access leftmost in $t3
           addi $t9, $zero, 24			# Reset shift length
           
           # Move $t3 into vector b array
set4:
           and $v0, $t3, $t7			# Get element
           srlv $v0, $v0, $t9			# Shift all the way to the right
           sw $v0, 0($s3)			# Store element into vector B array
           addi $s3, $s3, 4			# Move to next index of array
           srl $t7, $t7, 8			# Access next element in $t3
           addi $t9, $t9, -8 			# Decrement shift by 8
           bne $t9, -8, set4			# Loop back
	   	
           subi $s3, $s3, 32			# Reset to point to memory location 
	   					# with label "vectorB"
	 
           # Reinitialize for different use
           addi $v0, $zero, 0			# Use to index vector d
           addi $t6, $zero, 0			# To hold half for byte selection
           addi $t7, $zero, 8			# Byte count
           addi $t9, $zero, 24  		# Shift amount for correct place value
	   	
	   # Check which vector to get the element from
	    
loop:	   slti $v1, $t7, 5			# If byte count < 5 
           bne $v1, $zero, less_than_five	# to less_than_five
           beq $v1, $zero, greater_than_five	# to greater_than_five
		
less_than_five:				# Use $t5 of vector c since byte count < 5
           and $s6, $s5, $t5		# Get vector bits (0 or 1)
					# $s5 specifies the (left) half to access
					# $t5 is the right-most 32 bits of vector C
		
		
           and $t6, $s7, $t5		# Get byte selection
					# $s7 specifies the (right) nibble to access
					# $t5 is the right-most 32 bits of vector C	
           j continue
		
greater_than_five:			# Use $t4 of vector c since byte count < 5
           and $s6, $s5, $t4		# Get vector bits (0 or 1)
					# $s5 specifies the (left) half to access
					# $t4 is the left-most 32 bits of vector C
		
		
           and $t6, $s7, $t4		# Get byte selection
					# $s7 specifies the (right) half to access
					# $t4 is the left-most 32 bits of vector C	
continue:
           srl $s5, $s5, 8		# Shift for half for vector selection
           srl $s7, $s7, 8		# Shift for half for byte selection

           xor $v1, $t7, 4 		# if count != 3
           bne $v1, $zero, skipReset 	# go to skipReset
		
           addi $s5, $zero, 0xF0000000	# We're on byte 3, so reset the
           addi $s7, $zero, 0x0F000000	# vector and byte selection masking registers
           addi $t9, $zero, 24		# Reset shift amount
           and $s6, $s5, $t5		# Get vector bits (0 or 1)
					# $s5 specifies the (left) half to access
					# $t5 is the right-most 32 bits of vector C
		
		
           and $t6, $s7, $t5		# Get byte selection
					# $s7 specifies the (right) half to access
					# $t5 is the right-most 32 bits of vector C
           srl $s5, $s5, 8		# Shift for half for vector selection
           srl $s7, $s7, 8		# Shift for half for byte selection				
		
skipReset:  	
           beq $s6, $zero, usingVectorA	   # 0: use vector A
     					    
           bne $s6, $zero, usingVectorB	   # 1: use vector B
     	
           # Get one byte from vector a	
usingVectorA:	
           srlv $t6, $t6, $t9		# Shift to correct place value
           sll $t6, $t6, 2		# $t6 is used to hold half for byte selection
     	  				# Multiply it by 4 to use as index for vector A array
           add $t8, $t6, $s2		# Add offset to base address of vector A. Put it in $t8
           lw $t8, 0($t8)		# Load vector A element and store in $t8
           add $t6, $s4, $v0		# Add vector D index, $v0, to vector D base addr, $s4
           sw $t8, 0($t6)		# Store the vector A element into indexed vector D
           addi $v0, $v0, 4		# Increment vector D index by 4
     		
           j skipVectorB
     	
           # Get one byte from vector b	
usingVectorB:
 
           srlv $t6, $t6, $t9		# Shift to correct place value
           sll $t6, $t6, 2		# $t6 is used to hold half for byte selection
     	  				# Multiply it by 4 to use as index for vector B array
           add $t8, $t6, $s3		# Add offset to base address of vector B. Put it in $t8.
           lw $t8, 0($t8)		# Load vector B element and store in $t8
           add $t6, $s4, $v0		# Add vector D index, $v0, to vector D base addr, $s4
           sw $t8, 0($t6)		# Store the vector B element into indexed vector d
           addi $v0, $v0, 4		# Increment vector D index
     	
skipVectorB:	
           addi $t7, $t7, -1	# Decrement counter
           addi $t9, $t9, -8	# Decrement shift amount
           bne $t7, $zero, loop	# Keep looping
	  	
           # Put vector C array elements into destination ($s0 and $s1) "vector D"
		
           # Put the first four elements into $s0
           addi $t9, $zero, 4		# $t9 is the counter
           addi  $v1, $s4, 0		# $s4 has base addr of vector d
           addi $t6, $zero, 24		# Reinitialize to use as shift amount
		
first4Loop:
           lw $t7, 0($v1)		# Load vector d array element into $t7			
           sllv $t7, $t7, $t6		# Shift element to proper place
           add $s0, $s0, $t7		# Put into destination
           addi $v1, $v1, 4		# Increment index
           addi $t9, $t9, -1		# Decrement counter
           addi $t6, $t6, -8		# Decrement shift amount
           bne $t9, $zero, first4Loop	# Keep looping
		
           # Put the last four elements into $s1
           addi $t9, $zero, 4		# $t9 is the counter - reset it
					# Use same $v1
           addi $t6, $zero, 24		# Reinitialize shift amount
					
second4Loop:
           lw $t7, 0($v1)		# Load vector d array element into $t7			
           sllv $t7, $t7, $t6		# Shift element to proper place
           add $s1, $s1, $t7		# Put into destination
           addi $v1, $v1, 4		# Increment index
           addi $t9, $t9, -1		# Decrement counter
           addi $t6, $t6, -8		# Decrement counter
           bne $t9, $zero, second4Loop	# Keep looping

	 	                      	 	                      
           # End of Template 		
           #-------------------------------------------------------------
           # "Due diligence" to return control to the kernel
           #--------------------------------------------------------------
exit:      ori        $v0, $zero, 10    # $v0 <-- function code for "exit"
           syscall                      # Syscall to exit

           #*************************************************************
           #  P R O J E C T    R E L A T E D    S U B R O U T I N E S
           #*************************************************************
proc1:     j         proc1              # "placeholder" stub

           #*************************************************************
           #  P R O J E C T    R E L A T E D    D A T A   S E C T I O N
           #************************************************************* 
           .data                        # place variables, arrays, and
                                        # constants, etc. in this area
                                        
           # Making room to place our vectors                            
           vectorA:   .space 32		# Vector A equals 8 words 
           vectorB:   .space 32		# Vector B equals 8 words
           vectorD:   .space 32		# Vector C equals 8 words
