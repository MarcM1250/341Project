#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        07_vec_mergel.asm
# Version:          1.0
# Date:             November 26, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      Even elements of the result vector D are obtained left-to-right from the low 
#		    elements of vectors A. The odd elements of the result are obtained left-to-right
#		    from the low elements of vector B
#		    
#
# Register usage:   $s0: Upper 32 bits of vector d
#		    $s1: Lower 32 bits of vector d
#		    $t0: Upper 32 bits of vector a
#		    $t1: Lower 32 bits of vector a
#		    $t2: Upper 32 bits of vector b
#		    $t3: Lower 32 bits of vector b
#		    $t4: Used for byte selection
#		    $t5: Holds byte 4 of vector a or b
#		    $t6: Holds byte 5 of vector a or b
#		    $t7: Holds byte 6 of vector a or b
#		    $t8: Holds byte 7 of vector a or b
#
# Notes:     
#
#******************************************************************************************
	
           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text				# main (must be global)
           .globl main

           # Begin of Template 	
main:      #Initializations

          	# Setting testing values
           	addi $t0, $zero, 0x5AF0A501			
     	   	addi $t1, $zero, 0xAB0155C3
     	   	addi $t2, $zero, 0xA50F5A23			
     	   	addi $t3, $zero, 0xCD23AA3C			
     	   
     	   	# Clear storage registers
     	  	addi $s0, $zero, 0	
     	  	addi $s1, $zero, 0	
     	  	
	  	# Put each low element (byte) of vector a into a register
	   	
	   	# $s0
	   	andi $t4, $t1, 0xFF000000	# Get a[4]
	   	andi $t5, $t3, 0xFF000000	# Get b[4]
	   	srl  $t5, $t5, 8
	   	
	        andi $t6, $t1, 0x00FF0000	# Get a[5]
	   	andi $t7, $t3, 0x00FF0000	# Get b[5]
	   	srl  $t6, $t6, 8		# Shift right 1 byte
	   	srl  $t7, $t7, 16		# Shift right 2 byte
	   					# 0xAA00000 + 0x00BB000
		add $s4, $t4, $t5 		# $s4 = 0xAABB000 
						# 0000AA00 + 0x000000BB	
		add $s5, $t6, $t7		# $s5 = 0x0000AABB
		
		# Store in $s0 lower 32 bit of vector D
		add $s0, $s4, $s5
			
		# $s1
	   	andi $t4, $t1, 0x0000FF00	# Get a[6]
	   	andi $t5, $t3, 0x0000FF00	# Get b[6]
	   	sll  $t4, $t4, 16
	   	sll  $t5, $t5, 8
	   	
	        andi $t6, $t1, 0x000000FF	# Get a[7]
	   	andi $t7, $t3, 0x000000FF	# Get b[7]
	   	sll  $t6, $t6, 8		# Shift right 1 byte
	   					# 0xAA00000 + 0x00BB000
		add $s4, $t4, $t5 		# $s4 = 0xAABB000 
						# 0000AA00 + 0x000000BB	
		add $s5, $t6, $t7		# $s5 = 0x0000AABB
		
		# Store in $s0 upper 32 bit of vector D
		add $s1, $s4, $s5
		

	   	
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
