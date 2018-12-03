#*************************** 3 4 1   T o p    L e v e l   M o d u l e *************************
#
# File name:        06_vec_splat.asm
# Version:          1.0
# Date:             December 3, 2018  
# Programmers:      Anton Carrillo && Marc Marcelino
#
# Description:      This baseline instruction performs a vector splat. The splat
#		    instruction is used to copy any element from one vector into
#		    all of the elements of another vector. Each element of the
#		    result vector D is component B of vector A 
#		    			
# Register usage:   $s0: Upper 32 bits of vector d
#		    $s1: Lower 32 bits of vector d
#		    $t0: Upper 32 bits of vector a
#		    $t1: Lower 32 bits of vector a
#
#******************************************************************************************

           #**********************************************************
           #             M A I N     C O D E S E G M E N T  
           #**********************************************************

           .text                       		# main (must be global)
           .globl main

main:      #Initializations

           #Set by user
           addi $t0, $zero, 0x230C124D		# Upper 32 bits of vector A	
           addi $t1, $zero, 0x057F192A		# Lower 32 bits of vector A
           addi $t2, $zero, 3
           addi $t3, $zero, 7		
           addi $t8, $zero, 0xFF000000		# Mask to obtain element[i]
           addi $s4, $zero, 0x01010101		# Magic number to splat
     	   
           #Clear storage registers
           addi $s0, $zero, 0			# Upper 32 bits of vector D
           addi $s1, $zero, 0			# Upper 32 bits of vector D
           
           slti $t4, $t2, 4
           beq $t4, $zero, Lower32
           j Upper32
           
Lower32:
           subi $t7, $t2, 4
           mul  $t7, $t7, 8
           srlv $t8, $t8, $t7
           and $t8, $t8, $t1
           sub $t3, $t3, $t2
           mul  $t7, $t3, 8
           srlv $t8, $t8, $t7      
           j done
           
Upper32:	
           addi $t8, $zero, 0xFF000000
           mul  $t7, $t2, 8
           srlv $t8, $t8, $t7
           and $t8, $t8, $t0
           
           subi $t3, $t2, 4
           nor  $t3, $t3, $zero
           mul  $t7, $t3, 8
           srlv $t8, $t8, $t7      
                     
done:          	
	   mul $t8, $t8, $s4
           add $s0, $t8, $zero
           add $s1, $t8, $zero	
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


