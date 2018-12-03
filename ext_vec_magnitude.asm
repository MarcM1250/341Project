#*************************** 3 4 1   T o p    L e v e l   M o d u l e *************************
#
# File name:        ext_vec_magnitude.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      
#         This Instruction calculates the magnitude of a vector.
#         It uses the formula sqrt( [x1]^2 + [x2]^2 + ... + [xi]^2 )
#         which is the square root of the sum of its squared elements: 
#         The format for the instruction is the following:
#
#                        vec_magnitude c, a, b
#
#         "A" contains the base address to the vector
#         "B" contains the number of elements in the vector (dimension length)
#         "D" contains the magnitude of the vector (a scalar). The vector a can have an arbitrary 1-4 elements, 
#         which means that the vector can be 1-4 words wide or 8-128 bits wide. 
#
# Register usage:  
#         $s1: Holds base address of vector A
#         $s2: Number of elements in the vector (number of dimensions)
#         $v0: Use to compare number of elements with number of loops
#         $f1: Use to get vectorA[i]
#         $f2: Float temp used to save a vector element
#         $f3: Saves sum of squared elements
#         $f4: Destination register
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                        # main (must be global)
           .globl main

main:       # Setting testing values

            la $s1, vectorA               # Get address of vector and store in $s1
            addi $t4, $zero, 2            # Put values into vector a for testing
            sw   $t4, 0($s1)	
            addi $t4, $zero, 5            # Value 2
            sw   $t4, 4($s1)		
            addi $t4, $zero, 7            # Value 3
            sw   $t4, 8($s1) 

            addi   $s2, $zero, 3	         # User will set number of elements
            add    $t0, $s2, $zero        # Use number of elements as counter for loop
            sub.s  $f3, $f3, $f3          # Clear $f3 (Can't use $0 for FP add) 
    	    
            #Calculations     
contSqrSum:
            lwc1    $f1, 0($s1)           # Load vectora[i] into $f2
            cvt.s.w $f1, $f1              # Convert from word to single precision
            mul.s   $f2, $f1, $f1         # Square the element and store it in f2               

            
            add.s  $f3, $f3, $f2          # Add the square to the total sum of squared elements
            addi   $s1, $s1, 4            # Increment vectora index
            addi   $t0, $t0, -1           # Decrement counter
            bne    $t0, $0, contSqrSum    # Continue until we reached the end of the vector

            sqrt.s $f4, $f3               # Take the square root of the sum of squared elements
                                          # sqrt( x^2 + y^2 + z^2 + ... )  

            # End of Template 		
            #-------------------------------------------------------------
            # "Due diligence" to return control to the kernel
            #--------------------------------------------------------------
exit:       ori        $v0, $zero, 10    # $v0 <-- function code for "exit"
            syscall                      # Syscall to exit

            #*************************************************************
            #  P R O J E C T    R E L A T E D    S U B R O U T I N E S
            #*************************************************************
proc1:      j         proc1              # "placeholder" stub

            #*************************************************************
            #  P R O J E C T    R E L A T E D    D A T A   S E C T I O N
            #************************************************************* 
            .data                         # place variables, arrays, and
                                          # constants, etc. in this area

vectorA:    .space 16        # Vector A holds 4 words                
                      
    
