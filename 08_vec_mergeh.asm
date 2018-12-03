#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        08_vec_mergeh.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      Even elements of the result vector D are obtained left-to-right from the low 
#		    elements of vectors A. The odd elements of the result are obtained left-to-right
#		    from the low elements of vector B
#		    
#
# Register usage:   $s0: Upper 32 bits of vector d
#		    $s1: Lower 32 bits of vector d
#		    $t1: Lower 32 bits of vector a
#		    $t3: Lower 32 bits of vector b
#		    $t5: Holds byte 4 of vector a or b
#		    $t6: Holds byte 5 of vector a or b
#		    $t7: Holds byte 6 of vector a or b
#		    $t8: Holds byte 7 of vector a or b
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
	   	andi $t4, $t0, 0xFF000000	# Get a[0]
	   	andi $t5, $t2, 0xFF000000	# Get b[0]
	   	srl  $t5, $t5, 8
	   	
	        andi $t6, $t0, 0x00FF0000	# Get a[1]
	   	andi $t7, $t2, 0x00FF0000	# Get b[1]
	   	srl  $t6, $t6, 8		# Shift right 1 byte
	   	srl  $t7, $t7, 16		# Shift right 2 byte
	   					# 0xAA00000 + 0x00BB000
		add $s4, $t4, $t5 		# $s4 = 0xAABB000 
						# 0000AA00 + 0x000000BB	
		add $s5, $t6, $t7		# $s5 = 0x0000AABB
		
		# Store in $s0 lower 32 bit of vector D
		add $s0, $s4, $s5
			
		# $s1
	   	andi $t4, $t0, 0x0000FF00	# Get a[2]
	   	andi $t5, $t1, 0x0000FF00	# Get b[2]
	   	sll  $t4, $t4, 16
	   	sll  $t5, $t5, 8
	   	
	        andi $t6, $t0, 0x000000FF	# Get a[3]
	   	andi $t7, $t2, 0x000000FF	# Get b[3]
	   	sll  $t6, $t6, 8		# Shift right 1 byte
	   					# 0xAA00000 + 0x00BB000
		add $s4, $t4, $t5 		# $s4 = 0xAABB000 
						# 0000AA00 + 0x000000BB	
		add $s5, $t6, $t7		# $s5 = 0x0000AABB
		
		# Store in $s0 lower 32 bit of vector D
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

