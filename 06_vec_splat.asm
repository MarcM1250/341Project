#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:       06_vec_splat.asm
# Version:         1.0
# Date:            December 3, 2018  
# Programmer:      Anton Carrillo and Marc Marcelino 
#
# Description:     The vector splat instruction is used to select an element from one vector
#		   and copy it onto every element of another vector.
#		   vec_splat d, a, b is the format in which a is the vector being selected from,
#		   b is the number of the element being selected from a, and d is the vector 
#		   being copied onto.
#		   In this case, our format would be vec _splat $s0:$s1, $t0:$t1, $a0
# Register usage:   
#
#		    $t0: Elements 0-3 of Vector a
#		    $t1: Elements 4-7 of Vector a
#		    $s0: Elements 0-3 of Vector d
#		    $s1: Elements 4-7 of Vector d
#		    $a0: Elements 0-3 of Vector b / Element Selector
#
#		    $t2: Loop base number
#		    $s2: Loop limit
#		    $t3: Used to find address of element
#		    $t4: Holds address of elements
#		    $t5: Holds the selected element address for jumping to
#		    $t6: Holds the shifted position of vector a
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                       		# main (must be global)
           .globl main

main:      # Initialize Vectors + Values

	   	# a = 23_0C_12_4D_05_7F_19_2A
           	addi $t0, $zero, 0x230C124D	# Elements 0-3 of Vector a	
     	   	addi $t1, $zero, 0x057F192A	# Elements 4-7 of Vector a
     	   	
     	   	# b = 00_00_00_00_00_00_00_05 / Element Number
     	   	addi $a0, $zero, 5		# Elements 0-3 of Vector b
     	   
		# Set up Loop
		addi $t2, $zero, 0		# Starting value
		addi $s2, $zero, 3		# Limit at 3
	
		# Get address of element and jump to it
		sll $t3, $a0, 2   		# Multiply Element Number by 4 
		la  $t4, elements    		# Loads address of where the elements are stored
		add $t5, $t3, $t4     		# Saves address added with shifted element number
		lw $t5, 0($t5)   		# Load address into its own register
		jr $t5   			# Jump to address 
			
		# Element positions in vector d 
		# $t0 Elements 0-3
		E0:	srl $t6, $t0, 24	# Shifts to selected element 	
			j splat			# Performs splat with selection
			
		E1:	sll $t6, $t0, 8		# Shifts to selected element 
			srl $t6, $t6, 24
			j splat			# Performs splat with selection
			
		E2:	sll $t6, $t0, 16	# Shifts to selected element 
			srl $t6, $t6, 24
			j splat			# Performs splat with selection
			
		E3:	sll $t6, $t0, 24	# Shifts to selected element 
			srl $t6, $t6, 24
			j splat			# Performs splat with selection
			
		# $t1 Elements 4-7
		E4:	srl $t6, $t1, 24	# Shifts to selected element 
			j splat			# Performs splat with selection
			
		E5:	sll $t6, $t1, 8		# Shifts to selected element 
			srl $t6, $t6, 24
			j splat			# Performs splat with selection
			
		E6:	sll $t6, $t1, 16	# Shifts to selected element 
			srl $t6, $t6, 24
			j splat			# Performs splat with selection
			
		E7:	sll $t6, $t1, 24	# Shifts to selected element 
			srl $t6, $t6, 24
			j splat			# Performs splat with selection
			
	        # Perform the splat
splat:
		add $s0, $s0, $t6		# Adds selected element starting 
		add $s1, $s1, $t6		# at the lowest byte	
	
splat_loop:	
		sll  $t6, $t6, 8			# Shifts selection left and adds 
		add  $s0, $s0, $t6			# to remaining positions on both
		add  $s1, $s1, $t6			# registers that make up vector d
		
		# Loop
		addi $t2, $t2, 1		# Increment by 1			
		bne  $t2, $s2, splat_loop	# Stop at 3	

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
elements:
	   .word E0, E1, E2, E3, E4, E5, E6, E7
	   .text
	   
