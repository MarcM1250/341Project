#*************************** 3 4 1   T o p    L e v e l   M o d u l e *************************
#
# File name:        01_vec_addsu.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      This baseline instruction performs a vector add saturated (unsigned)
#		    operation. Each element of a is added to the corresponding element of b.
#		   
# Register Usage:   
#		    $s6: Upper 32 bits of vector d
#		    $s7: Lower 32 bits of vector d 
#		    $t0: Upper 32 bits of vector a
#		    $t1: Lower 32 bits of vector a
#		    $t2: Upper 32 bits of vector b
#		    $t3: Lower 32 bits of vector b
#
#		    $t4: Leftmost byte
#		    $t5: Sum of current elements from vectors a and b
#		    $t6: Rightmost element of upper 32 bits
#		    $t7: Equal to 1 when using lower 32 bits
#		    $s0: One byte of vector b 
#		    $t8: One byte of vector a
#		    $t9: Masks to access 8-bit element
#		    $v0: Equals to 0 when overflow does not happen
#		    $v1: Counter for vector elements
#
#******************************************************************************************
	
           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text				# main (must be global)
           .globl main

           # Begin of Template 	

main:      # ************* Code starts here ***********

           # Setting testing values
           addi $t0, $zero, 0x233C475D 	  # Upper 32 bits of vector a
           addi $t1, $zero, 0x087F196F		# Lower 32 bits of vector a
           addi $t2, $zero, 0x981963C5 		# Lower 32 bits of vector b       
           addi $t3, $zero, 0x5E80B36E		# Upwer 32 bits of vector b

           addi $s0, $zero, 0			        # Lower 32 bits of vector d to 0
           addi $s0, $zero, 0			        # Upper 32 bits of vector d to 0
           
           addi $v1, $zero, 8			        # Setting register to count bytes (8 bytes) d[i]
           addi $t6, $zero, 4			        # Use to check value of $v1
           
           addi $t4, $0, 0xFF000000		    # Mask to get 8 bits a[i], b[i]
         
loop:                          
           beq $v1, 8, exit			          # We are done	
           
           
           # End of Template 		
           #-------------------------------------------------------------
           # "Due diligence" to return control to the kernel
           #--------------------------------------------------------------
exit:      ori        $v0, $zero, 10     # $v0 <-- function code for "exit"
           syscall                       # Syscall to exit

           #*************************************************************
           #  P R O J E C T    R E L A T E D    S U B R O U T I N E S
           #*************************************************************
proc1:     j         proc1               # "placeholder" stub

           #*************************************************************
           #  P R O J E C T    R E L A T E D    D A T A   S E C T I O N
           #************************************************************* 
           .data                         # place variables, arrays, and
                                         # constants, etc. in this area
