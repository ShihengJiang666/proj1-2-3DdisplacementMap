.data

lfsr:
        .align 4
        .half
        0x1

.text

# Implements a 16-bit lfsr
#
# Arguments: None
lfsr_random:

        la $t0 lfsr
        lhu $v0 0($t0)

        # YOUR CODE HERE #
	
	li $t3 0
	li $t4 16

loop:
	beq $t3 $t4 print
	srl $t5 $v0 0
	srl $t6 $v0 2
	xor $t5 $t5 $t6
	srl $t6 $v0 3
	xor $t5 $t5 $t6
	srl $t6 $v0 5
	xor $t5 $t5 $t6

	sll $t5 $t5 15
	srl $t6 $v0 1
	or $v0 $t5 $t6
	andi $v0 $v0 65535
	addiu $t3 $t3 1
	j loop

print:
        la $t0 lfsr
        sh $v0 0($t0)
        jr $ra
