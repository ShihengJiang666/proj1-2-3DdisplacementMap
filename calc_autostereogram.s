.text

# Generates an autostereogram inside of buffer
#
# Arguments:
#     autostereogram (unsigned char*)
#     depth_map (unsigned char*)
#     width
#     height
#     strip_size
calc_autostereogram:

        # Allocate 5 spaces for $s0-$s5
        # (add more if necessary)
        addiu $sp $sp -20
        sw $s0 0($sp)
        sw $s1 4($sp)
        sw $s2 8($sp)
        sw $s3 12($sp)
        sw $s4 16($sp)

        # autostereogram
        lw $s0 20($sp)
        # depth_map
        lw $s1 24($sp)
        # width
        lw $s2 28($sp)
        # height
        lw $s3 32($sp)
        # strip_size
        lw $s4 36($sp)

        # YOUR CODE HERE #
        li $t5 -1 # t5 = i
        li $t1 -1 # t1 = j
        
L1:
	addiu $t5 $t5 1
	beq $t5 $s2 return # $s2 width
	li $t1 -1
	
L2:
	addiu $t1 $t1 1
	beq $t1 $s3 L1 # height = $s3
	slt $t4 $t5 $s4 # i < S
	beq $t4 $zero else
	#if 
	
	# allocating space for lfsr_random
	addiu $sp $sp -32
	sw $t0 0($sp)
	sw $t2 4($sp)
	sw $t3 8($sp)
	sw $t4 12($sp)
	sw $t5 16($sp)
	sw $t6 20($sp)
	sw $ra 24($sp)
	sw $t1 28($sp)
	jal lfsr_random # $v0 is returned
	#jal debug_random1
	#restoring space for lfsr_random
	lw $t0 0($sp)
	lw $t2 4($sp)
	lw $t3 8($sp)
	lw $t4 12($sp)
	lw $t5 16($sp)
	lw $t6 20($sp)
	lw $ra 24($sp)
	lw $t1 28($sp)
	addiu $sp $sp 32
	andi $v0 $v0 0xff
	mul $t2 $t1 $s2 # j * width
	addu $t2 $t2 $t5 # j * width + i
	addu $t2 $t2 $s0 # shifting for the address of auto[i, j]
	sb $v0 0($t2) # I(i,j) = random();
	j L2

else:
	mul $t3 $t1 $s2 # j * width 	
	addu $t3 $t3 $t5 # j * width + i
	addu $t3 $t3 $s1 # shifting for depth(i, j)
	lb $t3 0($t3) # depth(i, j)
	addu $t3 $t3 $t5 # i + depth(i,j)
	subu $t3 $t3 $s4 # i + depth(i,j) - S
	mul $t6 $t1 $s2 # j * width
	addu $t3 $t3 $t6 # j * width + (i + depth(i, j) - S)
	addu $t3 $t3 $s0 # I(above)
	lbu $t3 0($t3)
	mul $t6 $t1 $s2 # j * width
	addu $t6 $t6 $t5
	addu $t6 $t6 $s0
	sb $t3 0($t6)
	j L2
	
return:
        lw $s0 0($sp)
        lw $s1 4($sp)
        lw $s2 8($sp)
        lw $s3 12($sp)
        lw $s4 16($sp)
        addiu $sp $sp 20
        jr $ra
