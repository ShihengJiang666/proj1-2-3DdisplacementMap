.text

# Decodes a quadtree to the original matrix
#
# Arguments:
#     quadtree (qNode*)
#     matrix (void*)
#     matrix_width (int)
#
# Recall that quadtree representation uses the following format:
#     struct qNode {
#         int leaf;
#         int size;
#         int x;
#         int y;
#         int gray_value;
#         qNode *child_NW, *child_NE, *child_SE, *child_SW;
#     }

	
quad2matrix:

        # YOUR CODE HERE #
        addiu $sp $sp -8
	sw $ra, 0($sp)
	
        lw $t0 0($a0) # load leaf
        lw $t1 4($a0) # load size
        lw $t2 8($a0) # load x
        lw $t3 12($a0)	# load y
        lw $t4 16($a0) # load gray_value 
        bne $t0 $zero base

else:
	sw $a0, 4($sp)
	lw $a0, 20($a0)
	jal quad2matrix
	addiu $sp $sp 8
	lw $ra 0($sp)
	lw $a0, 4($sp)
	
	sw $a0, 4($sp)
	lw $a0, 24($a0)
	jal quad2matrix	
	addiu $sp $sp 8
	lw $ra 0($sp)
	lw $a0, 4($sp)
	
	sw $a0, 4($sp)
	lw $a0, 28($a0)
	jal quad2matrix
	addiu $sp $sp 8
	lw $ra 0($sp)
	lw $a0, 4($sp)
	
	
	sw $a0, 4($sp)
	lw $a0, 32($a0)
	jal quad2matrix
	addiu $sp $sp 8
	lw $ra 0($sp)
	lw $a0, 4($sp)
	
	jr $ra
	

      
base:
	addiu $t7 $t2 -1	#i: t7 = x
	addiu $t8 $t3 -1	#j: t8 = y
	addu $t5 $t2 $t1	#t5 = x+size
	addu $t6 $t3 $t1 #t6 = y+size
out:
	addiu $t8 $t8 1
	beq $t8 $t6 end #if y+size<y
	addiu $t7 $t2 -1	#i: t7 = x
in:
	addiu $t7 $t7 1
	beq $t7 $t5 out	
	mul $t9 $t8 $a2 # width * j
	addu $t9 $t9 $t7 # width * j + i
	add $t9 $t9 $a1 # shifting for matrix position
	sb $t4 0($t9) # saving gray_value to matrix position
	j in

end:
	  jr $ra

