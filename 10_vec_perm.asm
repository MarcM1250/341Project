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
#		    of A or B is mapped to element [j] of the vector D. Each "element spacifier"
# 		    in vector C has two componentes: the most-significant-half specifies an
#		    element from either vector A or B (0=A, 1=B)
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

           #Set by user
           addi $t0, $zero, 0xA567013D	#Vector a		
           addi $t1, $zero, 0xAB45393C
           addi $t2, $zero, 0xEFC54D23	#Vector b		
           addi $t3, $zero, 0x1277AACD			
           addi $t4, $zero, 0x04171002	#Vector c		
           addi $t5, $zero, 0x13050105
              	   
           #Clear storage registers
           addi $s0, $zero, 0		#Vector d
           addi $s1, $zero, 0  	


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


vectora:   .space 32			 # Vector A holds 8 words	   
vectorb:   .space 32			 # Vector B holds 8 words
vectord:   .space 32			 # Vector D holds 8 words

