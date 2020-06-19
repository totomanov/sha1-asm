# SHA-1 hashing algorithm in X86 Assembly.
# Reference: https://en.wikipedia.org/wiki/SHA-1#Examples_and_pseudocode
# Author: Anton Totomanov

.global sha1_chunk
.text
sha1_chunk:
	pushq %r8			#push %r8 on the stack
	pushq %r9			#push %r9 on the stack
	pushq %r10			#push %r10 on the stack
	pushq %r11			#push %r11 on the stack
	pushq %r12			#push %r12 on the stack
	pushq %r13			#push %r13 on the stack
	pushq %r14			#push %r14 on the stack
	pushq %r15			#push %r15 on the stack


	movq $16, %r14			#loading 16 in the counter for i in w[i]
	movq $16, %rbx			#loading 16 in the counter for moving the result to %rsi
loop:   #80 words
	subq $3, %r14			#w[i-3]
	movl (%rsi, %r14, 4), %r8d	#getting the value in w[i-3] and loading it in %r8d

	subq $5, %r14			#w[i-8]
	movl (%rsi, %r14, 4), %r9d	#getting the value in w[i-8] and loading it in %r9d

	xorl %r9d, %r8d			#xor Value destination; we have in %r8d the result

	subq $6, %r14			#w[i-14]
	movl (%rsi, %r14, 4), %r9d	#getting the value in w[i-14] and loading it in %r9d

	xorl %r9d, %r8d			#xor in %r8d

	subq $2, %r14			#w[i-16]
	movl (%rsi, %r14, 4), %r9d	##getting the value in w[i-16] and loading it in %r9d

	xorl %r9d, %r8d			#the result in %r8d is w[i] before the left rol

	roll $1, %r8d			#final w[i] value
	movl %r8d, (%rsi, %rbx, 4)	#loading w[i] in the array
	addq $1, %rbx			#adding 1 to %rbx, for the next w[i+1]
	addq $17, %r14			#restoring the counter for the offset and adding 1 to it
	cmpq $79, %r14			#comparing the counter for the offset with 79

	jle loop			#repeat until the counter is not equal to 79

initialize:
	movl (%rdi), %r9d  		#loading the value of h0 in %r9d	a
	movl 4(%rdi), %r10d		#loading the value of h1 in %r10d	b
	movl 8(%rdi), %r11d		#loading the value of h2 in %r11d	c
	movl 12(%rdi), %r12d		#loading the value of h3 in %r12d	d
	movl 16(%rdi), %r13d		#loading the value of h4 in %r13d	e
	movq $0, %rbx			#loading the value 0 in %rbx
	movl $0, %r14d			#loading the value 0 in %r14d

loop1:
	movl %r10d, %ecx		#loading the value of b in %ecx
	movl %r10d, %r14d		#loading the value of b in %r14d
	movl %r10d, %r8d		#loading the value of b in %r8d
	andl %r11d, %r10d		#b and c, stored in %r10d
	notl %ecx			#not b
	andl %r12d, %ecx		#((not b) and d) stored in %ecx
	orl %r10d, %ecx			#(b and c) or ((not b) and d), stored in %ecx; f
	
	movl $0, %r15d			#loading the value 0 in %r15d

	roll $5, %r9d			#left rotate with 5 bits
	addl %r9d, %r15d		#adding the result of left rotate a to %r15d
	addl %ecx, %r15d		#adding the value of f to %r15d
	addl %r13d, %r15d		#adding the value of e to %r15d
	addl $0x5A827999, %r15d		#adding the value of k to %r15d
	addl (%rsi, %rbx, 4), %r15d 	#adding the w[i] to %r15d; TEMP

	rorl $5, %r9d			#right rotate with 5 bits to restore the previous value of a
	movl %r8d, %r10d		#restoring the value of b
	movl %r12d, %r13d		#loading the value of d into e
	movl %r11d, %r12d		#loading the value of c into d
	movl %r10d, %r11d		#loading the value of c into b
	roll $30, %r11d			#left rotating the value of b with 30 bits
	movl %r9d, %r10d		#loading the value of a into b
	movl %r15d, %r9d		#loading the value of temp into a

	addq $1, %rbx			#adding 1 to our counter
	cmpq $19, %rbx			#comparing our counter with 19
		
	jle loop1			#repeat until the counter is not equal to 19

loop2:
	movl %r10d , %ecx		#loading the value of b into %ecx
	xorl %r11d, %ecx		#c xor b the value is stored in %ecx
	xorl %r12d, %ecx		#(c xor b) xor d, the value is stored in %ecx

	movl $0, %r15d			#loading the value 0 in %r15d

	roll $5, %r9d			#left rotate with 5 bits
	addl %r9d, %r15d		#adding the result of left rotate a to %r15d
	addl %ecx, %r15d		#adding the value of f to %r15d
	addl %r13d, %r15d		#adding the value of e to %r15d
	addl $0x6ED9EBA1, %r15d		#adding the value of k to %r15d
	addl (%rsi, %rbx, 4), %r15d 	#adding the w[i] to %r15d; TEMP

	rorl $5, %r9d			#right rotate with 5 bits to restore the previous value of a
	movl %r12d, %r13d		#loading the value of d into e
	movl %r11d, %r12d		#loading the value of c into d
	movl %r10d, %r11d		#loading the value of c into b
	roll $30, %r11d			#left rotating the value of b with 30 bits
	movl %r9d, %r10d		#loading the value of a into b
	movl %r15d, %r9d		#loading the value of temp into a
	
	addq $1, %rbx			#adding 1 to our counter
	cmpq $39, %rbx			#comparing our counter with 39
	
	jle loop2			#repeat until the counter is not equal to 39

loop3:	
	movl %r10d, %ecx		#loading the value of b in %ecx
	movl %r10d, %r8d		#loading the value of b in %r8d
	movl %r11d, %r15d		#loading the value of c in %r15d
	andl %r11d, %ecx 		#c and b, the value is stored in b "ecx"
	andl %r12d, %r10d 		#d and b, the value is stored in b "r10d" 
	andl %r12d, %r15d 		#d and c, the value is stored in c "r15d"
	orl %r10d, %ecx			#(d and b) or (c and b), stored in "ecx"
	orl %r15d, %ecx			#(d and c) or ((d and b) or (c and b)) stored in "ecx"

	movl $0, %r15d			#loading the value 0 in %r15d

	roll $5, %r9d			#left rotate with 5 bits
	addl %r9d, %r15d		#adding the result of left rotate a to %r15d
	addl %ecx, %r15d		#adding the value of f to %r15d
	addl %r13d, %r15d		#adding the value of e to %r15d
	addl $0x8F1BBCDC, %r15d		#adding the value of k to %r15d
	addl (%rsi, %rbx, 4), %r15d 	#adding the w[i] to %r15d; TEMP

	rorl $5, %r9d			#right rotate with 5 bits to restore the previous value of a
	movl %r8d, %r10d		#restoring the value of b
	movl %r12d, %r13d		#loading the value of d into e
	movl %r11d, %r12d		#loading the value of c into d
	movl %r10d, %r11d		#loading the value of c into b
	roll $30, %r11d			#left rotating the value of b with 30 bits
	movl %r9d, %r10d		#loading the value of a into b
	movl %r15d, %r9d		#loading the value of temp into a


	addq $1, %rbx			#adding 1 to the counter
	cmpq $59, %rbx			#comparing the counter to 59

	jle loop3			#repeat until the counter is not equal to 59
loop4:
 	movl %r10d, %ecx		#loading the value of b into %ecx
	xorl %r11d, %ecx		#c xor b, result stored into %ecx
	xorl %r12d, %ecx		#d xor (c xor b), result stored into %ecx

	movl $0, %r15d			#loading the value 0 in %r15d
	
	roll $5, %r9d			#left rotate with 5 bits
	addl %r9d, %r15d		#adding the result of left rotate a to %r15d
	addl %ecx, %r15d		#adding the value of f to %r15d
	addl %r13d, %r15d		#adding the value of e to %r15d
	addl $0xCA62C1D6, %r15d		#adding the value of k to %r15d
	addl (%rsi, %rbx, 4), %r15d 	#adding the w[i] to %r15d; TEMP

	rorl $5, %r9d			#right rotate with 5 bits to restore the previous value of a
	movl %r12d, %r13d		#loading the value of d into e
	movl %r11d, %r12d		#loading the value of c into d
	movl %r10d, %r11d		#loading the value of c into b
	roll $30, %r11d			#left rotating the value of b with 30 bits
	movl %r9d, %r10d		#loading the value of a into b
	movl %r15d, %r9d		#loading the value of temp into a

	addq $1, %rbx			#adding 1 to the counter
	cmpq $79, %rbx			#comparing the counter with 79

	jle loop4			#repeat until the counter is not equal to 79
hashto:
	addl %r9d, (%rdi)		#adding the result of "a" to h0
	addl %r10d, 4(%rdi)		#adding the result of "b" to h1
	addl %r11d, 8(%rdi)		#adding the result of "c" to h2
	addl %r12d, 12(%rdi) 		#adding the result of "d" to h3
	addl %r13d, 16(%rdi)		#adding the result of "e" to h4
end:
	popq %r15			#pop %r15 , and return it to it's previous value
	popq %r14			#pop %r14 , and return it to it's previous value
	popq %r13			#pop %r13 , and return it to it's previous value
	popq %r12			#pop %r12 , and return it to it's previous value
	popq %r11			#pop %r11 , and return it to it's previous value
	popq %r10			#pop %r10 , and return it to it's previous value
	popq %r9			#pop %r9 , and return it to it's previous value
	popq %r8			#pop %r8 , and return it to it's previous value
	ret				#returning to the main function

