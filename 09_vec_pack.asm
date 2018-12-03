#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        09_vec_pack.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      Each high element of the result vector D is the truncation of the corresponding
#		    wider element of vector A. Each low element of the result is the truncation of
#		    the corresponding wider element of vector B.
#	
# Register usage:  
#		    $s1: Shift amount for lower 32 bits
#		    $s2: Shift amount for upper 32 bits
#		    $s0: Upper 32 bits of vector d
#		    $s1: Lower 32 bits of vector d 
#		    $t1: Lower 32 bits of vector a
#		    $t0: Upper 32 bits of vector a
#		    $t3: Lower 32 bits of vector b
#		    $t2: Upper 32 bits of vector b
#		    $t8: Masks that allows us to access 4 bits of a vector
#		    $t9: Holds shifting value
#		    $v1: Counter for vector elements
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                        # main (must be global)
           .globl main

main:      #Initializations
           addi $s0, $zero, 0			# Clear register to store upper 32 bits
           addi $s1, $zero, 0			# Clear register to store lower 32 bits
           addi $v1, $zero, 0			# Counter
           addi $t9, $zero, 4			# Shift legth
			
           addi $t8, $zero, 0x0F000000		# Use to access the 4 bits from current element

           addi $t0, $zero, 0x5AFB6C1D		# Initialize upper 32 bits of vector a
           addi $t1, $zero, 0xAE5FC041 	        # Initialize lower 32 bits of vector a
           addi $t2, $zero, 0x52F3A415		# Initialize upper 32 bits of vector b
           addi $t3, $zero, 0xA657C849 		# Initialize lower 32 bits of vector b
                           
miniLoop1:  
           beq $v1, 4, exitMiniLoop1    
           and $t4, $t0, $t8		# Get 4 bits from upper 32 bits of vector A
           and $t5, $t2, $t8		# Get 4 bits from upper 32 bits of vector B
           
           sllv $t4, $t4, $t9		# Shift left 4 bits
           sllv $t5, $t5, $t9		# Shift left 4 bits
           
           add $s0, $s0, $t4		# Save result in upper vector D
           add $s1, $s1, $t5		# Save result in lower vector D
           
           addi $t9, $t9, 4
           srl $t8, $t8, 8		# Shift right 8 bits to grab next element
           addi $v1, $v1, 1
           j miniLoop1
	   
exitMiniLoop1:  
           addi $t8, $zero, 0x0F000000	# Reset mask	    
           addi $t9, $zero, 12		# Set offset for shifting
           
miniLoop2:
           beq $v1, 8, exit    
           and $t4, $t1, $t8		# Get 4 bits from lower 32 bits of vector A
           and $t5, $t3, $t8		# Get 4 bits from lower 32 bits of vector B
           
           srlv $t4, $t4, $t9		# Shift left 12, 8, 4, 0 bits
           srlv $t5, $t5, $t9		# Shift left 12, 8, 4, 0 bits
           
           add $s0, $s0, $t4		# Save result in upper vector D
           add $s1, $s1, $t5		# Save result in lower vector D
           
           addi $t9, $t9, -4
           srl $t8, $t8, 8		# Shift right 8 bits to grab next element
           addi $v1, $v1, 1
           j miniLoop2
					
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
