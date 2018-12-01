#*************************** SIMD MIPS Baseline Instructions *****************************
#
# File name:        05_vec_msums.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmer:       Anton Carrillo && Marc Marcelino
#
# Description:
#       This instruction builds a vector d whereas each element of vector d is the 16 bit sum of
#		    corresponding elements of vector c and the 16 bit "temp" products of the 8 bit elements
#		    of vector b which ovelap the positions of that element in c. The sum is performed with
#		    16 bit saturating addition (no wrap)
#
# Register usage:
#       $s0: Upper 32 bits of vector c
#		    $s1: Lower 32 bits of vector c
#		    $s2: Upper 32 bits of vector d
#		    $s3: Lower 32 bits of vector d
#
#		    $t0: Upper 32 bits of vector a
#		    $t1: Lower 32 bits of vector a
#		    $t2: Upper 32 bits of vector b
#		    $t3: Lower 32 bits of vector b
#		    $t4: Holds the byte product 
#		    $t5: Sum of products elements a[i]*b[i] and a[i+1]*b[i+1] and c[2i]
#		    $t6: 8-bit element of vector a 
#		    $t7: 8-bit element of vector b
#		    $t8: 16 bit element of vector d
#		    $v0: Check for Overflow 
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                        # main (must be global)
           .globl main

main:      # Initializations
           addi $s7, $zero, 0			# Clear register to store lower 32 bits
           addi $s6, $zero, 0			# Clear register to store upper 32 bits

           # Set by user
           addi $t0, $zero, 0x230CF14D 	        # Set upper 32 bits of vector a
           addi $t1, $zero, 0x5C7F191A		# Set lower 32 bits of vector a
           addi $t2, $zero, 0xA30C5BFD 		# Set upper 32 bits of vector b       
           addi $t3, $zero, 0xC5FFC9EE		# Set lower 32 bits of vector b
           addi $s0, $zero, 0x609E19F7		# Set upper 32 bits of vector c
           addi $s1, $zero, 0x45670766		# Set lower 32 bits of vector c

           # Calculate d[3]	
           andi $t6, $t1, 0x000000FF		# Get byte from a[7]
           andi $t7, $t3, 0x000000FF		# Get byte from b[7]
           mulo $t4, $t6, $t7			# Multiply bytes

           andi $t6, $t1, 0x0000FF00		# Get byte from a[6]
           andi $t7, $t3, 0x0000FF00		# Get byte from b[6]
           srl $t6, $t6, 8			# Shit 8 bits to right
           srl $t7, $t7, 8			# Shit 8 bits to right
           mulo $t5, $t6, $t7			# Multiply bytes

           add $t5, $t4, $t5			# Add products

           andi $t8, $s1, 0x0000FFFF		# Get 16 bits from c[3]
           add $t5, $t5, $t8			# Add the 16 bits to the sum of products

           andi $v0, $t5, 0x0000FFFF		# Get result without carry out
           sub $v0, $t5, $v0 			
           beq $v0, $zero, index3_no_OVF		# Check for overflow
           addi $t5, $zero, 0x0000FFFF		# Overflowed, lets saturate

  index3_no_OVF:
           add $s3, $s3, $t5			# Save result in d[3]

           # Calculate d[2]
           andi $t6, $t1, 0x00FF0000		# Get byte from a[5]
           andi $t7, $t3, 0x00FF0000		# Get byte from b[5]
           srl $t6, $t6, 16			# Shit 16 bits to right
           srl $t7, $t7, 16			# Shit 16 bits to right
           mulo $t4, $t6, $t7 			# Multiply bytes

           andi $t6, $t1, 0xFF000000		# Get byte from a[4]
           andi $t7, $t3, 0xFF000000		# Get byte from b[4]
           srl $t6, $t6, 24			
           srl $t7, $t7, 24			
           mulo $t5, $t6, $t7			# Multiply bytes

           add $t5, $t4, $t5			# Add products

           andi $t8, $s1, 0xFFFF0000		# Get 16 bits from c[2]
           srl $t8, $t8, 16			
           add $t5, $t5, $t8			# Add the 16 bits to the sum of products

           andi $v0, $t5, 0x0000FFFF		# Get result without carry out
           sub $v0, $t5, $v0			
           sll $t5, $t5, 16 			# Shift to align with to d[2] 
           beq $v0, $zero, index2_no_OVF	# Check for overflow
           addi $t5, $zero, 0xFFFF0000		# Overflowed, lets saturate 				
	   				
index2_no_OVF:
           add $s3, $s3, $t5			# Save result in d[2]

           # Calculate d[1]	
           andi $t6, $t0, 0x000000FF		# Get byte from a[3]
           andi $t7, $t2, 0x000000FF		# Get byte from b[3]
           mulo $t4, $t6, $t7			# Multiply bytes

           andi $t6, $t0, 0x0000FF00		# Get byte from a[2]
           andi $t7, $t2, 0x0000FF00		# Get byte from b[2]
           srl $t6, $t6, 8			# Shit 8 bits to right
           srl $t7, $t7, 8			# Shit 8 bits to right
           mulo $t5, $t6, $t7			# Multiply bytes

           add $t5, $t4, $t5			# Add products

           andi $t8, $s0, 0x0000FFFF		# Get 16 bits from c[1]
           add $t5, $t5, $t8			# Add the 16 bits to the sum of products

           andi $v0, $t5, 0x0000FFFF		# Get result without carry out
           sub $v0, $t5, $v0 			
           beq $v0, $zero, index1_no_OVF	# Check for overflow
           addi $t5, $zero, 0x0000FFFF		# Overflowed, lets saturate
	  
index1_no_OVF:
           add $s2, $s2, $t5			# Save result in d[1]

           # Calculating d[0]
           andi $t6, $t0, 0x00FF0000		# Get byte from a[5]
           andi $t7, $t2, 0x00FF0000		# Get byte from b[5]
           srl $t6, $t6, 16			# Shit 16 bits to right
           srl $t7, $t7, 16			# Shit 16 bits to right
           mulo $t4, $t6, $t7 			# Multiply bytes

           andi $t6, $t0, 0xFF000000		# Get byte from a[4]
           andi $t7, $t2, 0xFF000000		# Get byte from b[4]
           srl $t6, $t6, 24			
           srl $t7, $t7, 24			
           mulo $t5, $t6, $t7			# Multiply bytes

           add $t5, $t4, $t5			# Add products

           andi $t8, $s0, 0xFFFF0000		# Get 16 bits from c[2]
           srl $t8, $t8, 16			
           add $t5, $t5, $t8			# Add the 16 bits to the sum of products

           andi $v0, $t5, 0x0000FFFF		# Get result without carry out
           sub $v0, $t5, $v0			
           sll $t5, $t5, 16 			# Shift to align with to d[2] 
           beq $v0, $zero, index0_no_OVF	# Check for overflow
           addi $t5, $zero, 0xFFFF0000		# Overflowed, lets saturate 				
	   				
index0_no_OVF:
            add $s2, $s2, $t5			# Save result in d[2]

           #-----------------------------------------------------------
           # "Due diligence" to return control to the kernel
           #-----------------------------------------------------------
exit:      ori        $v0, $zero, 10     # $v0 <-- function code for "exit"
           syscall                       # Syscall to exit


           #************************************************************
           #  P R O J E C T    R E L A T E D    S U B R O U T I N E S
           #************************************************************
proc1:     j         proc1               # "placeholder" stub

