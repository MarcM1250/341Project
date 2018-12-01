#*************************** 3 4 1   T o p    L e v e l   M o d u l e *************************
#
# File name:        03_mulo.asm
# Version:          1.0
# Date:             November 26, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      Each element of vector d is the full-length (16 bit) product of the 
#		    corresponding low (odd) half-width elements of vector a and vector b
#		   
# Register Usage:
#		      $t0: Upper 32 bits of vector a
#		      $t1: Lower 32 bits of vector a
#		      $t2: Upper 32 bits of vector b
#		      $t3: Lower 32 bits of vector b
#		      $s0: Upper 32 bits of vector d
#		      $s1: Lower 32 bits of vector d 
#
#		      $t5: Used for temporary arithmetic operations
#		      $t6: Used for temporary arithmetic operations
#		      $t7: Used for temporary arithmetic operations
#
#******************************************************************************************
	
           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text			# main (must be global)
           .globl main

           # Begin of Template 	
           
main:      # ************* Code starts here ***********

           # Setting testing values
           addi $t0, $zero, 0xAEE95AE0			
           addi $t1, $zero, 0xF080CC66	
           addi $t2, $zero, 0x33146170	
           addi $t3, $zero, 0x609888AB	

           # Clear storage registers
           add $s0, $zero, $zero
           add $s1, $zero, $zero

           # $s0 ############################################################
           # Getting odd bytes from $t0 
           sll $t5, $t0, 24		# left three bytes 	
           srl $t5, $t5, 24		# right three bytes
           sll $t4, $t0, 8		# left one byte
           srl $t4, $t4, 24	   	# right three bytes

           # Getting odd bytes from $t2 
           sll $t7, $t2, 24		 	
           srl $t7, $t7, 24	
           sll $t6, $t2, 8		# left one byte
           srl $t6, $t6, 24	   	# right three bytes	   	

           # Multiply odd bytes and save them in lower 32 vector d ($s0)

           mult $t4, $t6		# $t4 = s0[1]*s0[3] 
           mflo $t4			# $t4 = 0x0000XXXX
           sll $s0, $t4, 16		# $s0 = 0xXXXX0000

           mult $t5, $t7		
           mflo $t5			# $t5 = 0x0000YYYY
           add $s0, $s0, $t5		# $s0 = 0xXXXXYYYY

           # $s1 ############################################################
           # Getting odd bytes from $t1 
           sll $t5, $t1, 24		# left three bytes 	
           srl $t5, $t5, 24		# right three bytes
           sll $t4, $t1, 8		# left one byte
           srl $t4, $t4, 24	   	# right three bytes

           # Getting odd bytes from $t3 
           sll $t7, $t3, 24		 	
           srl $t7, $t7, 24	
           sll $t6, $t3, 8		# left one byte
           srl $t6, $t6, 24	   	# right three bytes	   	

           # Multiply odd bytes and save them in upper 32 vector d ($s1)

           mult $t4, $t6		
           mflo $t4
           sll $s1, $t4, 16		

           mult $t5, $t7		
           mflo $t5
           add $s1, $s1, $t5		# $s1 = 0xXXXXYYYY

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
                                         
                                         
