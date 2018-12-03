#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        02_vec_madd.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      Vector D is the result of multiplying the vector elements in A by the
#		    vector elements in B and then the intermediate result is add to the
#		    vector elements in C. Note that the sum of the intermediate product with 
#		    elements in vector C are "truncated" for half-lengh results placed into
#		    vector D

#	
# Register usage:  
#		    $s0: Lower 32 bits of vector d
#		    $s1: Upper 32 bits of vector d
#
#		    $t0: Lower 32 bits of vector a 
#		    $t1: Upper 32 bits of vector a
#		    $t2: Lower 32 bits of vector b
#		    $t3: Upper 32 bits of vector b
#		    $t4: Lower 32 bits of vector c
#		    $t5: Upper 32 bits of vector c
#
#		    $t8: Mask that allows us to access 4 bits of a vector
#		    $t9: Holds shifting value
#		    $v1: Counter for vector elements
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text	                        # main (must be global)
           .globl main

main:      #Initializations
           addi $s0, $zero, 0			# Clear register to store upper 32 bits D
           addi $s1, $zero, 0			# Clear register to store lower 32 bits D
           					
	   addi $v1, $zero, 0			# Counter
	   				
           addi $t8, $zero, 0xFF000000		# Use to access the 4 bits from current element

           addi $t0, $zero, 0x23051912		# Initialize upper 32 bits of vector a
           addi $t1, $zero, 0x120C1A0D 	        # Initialize lower 32 bits of vector a
           addi $t2, $zero, 0x057F192B		# Initialize upper 32 bits of vector b
           addi $t3, $zero, 0x3D0C104D 		# Initialize lower 32 bits of vector b       
           addi $t4, $zero, 0x501E0660		# Initialize upper 32 bits of vector c
           addi $t5, $zero, 0x60091B05		# Initialize lower 32 bits of vector c
           
           addi $t9, $zero, 24			# initial shifting value

loopLower32:                      
           beq $v1, 4, exitLoopLower32			
           
           # Upper 32 bits
           
           and $t6, $t1, $t8			# Get one byte from vector A 
           and $t7, $t3, $t8			# Get one byte from vector B
           and $s4, $t5, $t8			# Get one byte from vector C
           
           srlv, $t6, $t6, $t9			# Shift all the values 
           srlv, $t7, $t7, $t9			# to perform a risk-free
           srlv, $s4, $s4, $t9			# multiplication and addition
           
           mult $t6, $t7			# Get the product of a[i]*b[i]
           mflo $t7				# Move it out from Lo into $t7
           
           add $s4, $s4, $t7			# Add c[i] to a[i]*b[i]
           and $s4, $s4, 0x000000FF		# Get only one byte lengh  
           
           sllv $s4, $s4, $t9			# Realign the result
           add $s0, $s0, $s4			# Save result into Upper register D
           
           srl, $t8, $t8, 8			# Set next shift value
           addi $t9, $t9, -8			# Adjust shifting for operations
           					# in the next loop
           
           addi $v1, $v1, 1
                 
           j loopLower32

exitLoopLower32:
	   addi $t8, $zero, 0xFF000000		# Use to access the 4 bits from current element         
	   
           # Lower 32 bits                       
loopUpper32:                      
           beq $v1, 8, exit			# We are done     
           
           and $t6, $t0, $t8			# Get one byte from vector A 
           and $t7, $t2, $t8			# Get one byte from vector B
           and $s4, $t4, $t8			# Get one byte from vector C
           
           srlv, $t6, $t6, $t9			# Shift all the values 
           srlv, $t7, $t7, $t9			# to perform a risk-free
           srlv, $s4, $s4, $t9			# multiplication and addition
           
           mult $t6, $t7			# Get the product of a[i]*b[i]
           mflo $t7				# Move it out from Lo into $t7
           
           add $s4, $s4, $t7			# Add c[i] to a[i]*b[i]
           and $s4, $s4, 0x000000FF		# Get only one byte lengh  
           
           sllv $s4, $s4, $t9			# Realign the result
           add $s1, $s1, $s4			# Save result into lower register D
           
           srl, $t8, $t8, 8			# Set next shift value
           addi $t9, $t9, -8			# Adjust shifting for operations
           					# in the next loop
           
           addi $v1, $v1, 1
                 
           j loopUpper32          

           #-----------------------------------------------------------
           # "Due diligence" to return control to the kernel
           #-----------------------------------------------------------
exit:      ori        $v0, $zero, 10     # $v0 <-- function code for "exit"
           syscall                       # Syscall to exit

           #************************************************************
           #  P R O J E C T    R E L A T E D    S U B R O U T I N E S
           #************************************************************
proc1:     j         proc1               # "placeholder" stub

           #************************************************************
           # P R O J E C T    R E L A T E D    D A T A   S E C T I O N
           #************************************************************ 
           .data                         # place variables, arrays, and
                                         # constants, etc. in this area
