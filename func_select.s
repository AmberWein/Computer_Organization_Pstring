// Amber Weiner 208783522

# This is a func_select program that send to the match function according to the option that was chosen

.section	.rodata		#read only data section
.pstrlenStr:
	.string	"first pstring length: %d, second pstring length: %d\n"

.scanf1:
	.string	" %c"

.format1:
	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"

.scanf2:
	.string	" %hhu"

.format2:
	.string	"length: %d, string: %s\n"

.format4:
    .string "length: %d, string: %s\n"

.format5:
    .string "compare result: %d\n"

.formatError:
	.string	"invalid option!\n"

	.align 8
switch_case:
	.quad	case50
	.quad   caseDefault #invalid case
	.quad	case52
	.quad	case53
	.quad	case54
	.quad	case55
	.quad   caseDefault #invalid case
	.quad   caseDefault #invalid case
	.quad   caseDefault #invalid case
	.quad   caseDefault #invalid case
	.quad	case60

	##################################
	.text	# the beginning of the code
.globl	run_func
	.type	run_func, @function
run_func:
    	pushq	%rbp
    	movq	%rsp, %rbp
    	// set the jump table access
    	leaq -50(%rdi), %rax
    	cmpq $10, %rax              # compare rax with 10
    	ja caseDefault              # by default, go to caseDefault label
    	jmp	*switch_case(,%rax,8)	# else jump using jump table

    # if the user input case 50:
    # gets two Pstrinngs and prints their length
    # using the function pstrlen
    case50:
        # push callee save r12, r13 to stack
       push	%r12
       push %r13
       movq %rdx,%r12	    	# move 3rd argument (pstr2) to r12
       movq	%r12,%rdi
       call	pstrlen			    # send to function that return the length of pstr2
       movsbl %al, %ebx		    # save the return value from the function move to register

       movq %rsi,%r13	    	# move 2nd argument (pstr1) to r13
       movq	%r13,%rdi
       call	pstrlen			    # send to function that return the length of pstr1
       movsbl %al, %eax		    # return the value (char) from the function move to register

       movl	%ebx, %edx		    # move pstrlen(p2) to parameter third - to print
       movl	%eax, %esi		    # move pstrlen(p1) to parameter second - to print
       movl	$.pstrlenStr, %edi	# move string to parameter first - to print
       movq	$0, %rax	    	# initalize before get into function
       call	printf		    	# print the length of both srings
       # restore saved registers:r13,r12
       pop %r13
       pop %r12

	   jmp done                 # end program

    # if the user input case 52:
    # gets old char and new char and replace every old char in the Pstring with a new char.
    # Doing that by calling the function replaceChar
    case52:
        sub     $16, %rsp
        # push callee save r12/r13/r14/r15 to stack
        push    %r12
        push    %r13
        push    %r14
        push    %r15
        movq    %rsi,%r12   		# move 2nd argument (pstr1) to r12
        movq    %rdx,%r13   		# move 3rd argument (pstr2) to r13

        # get the first char- old char
        leaq    -8(%rbp),%rsi
        movq    $.scanf1, %rdi
        movq    $0, %rax            # initalize before get into function
        call    scanf
        movzbq  -8(%rbp), %r14

        # get the second char- new char
        leaq    -16(%rbp), %rsi
        movq    $.scanf1, %rdi
        movq    $0, %rax            # initalize before get into function
        call    scanf
        movzbq  -16(%rbp), %r15

        # replaceChar for the first pstring
        movq    $0, %rax            # initalize before get into function
        movq    %r12, %rdi		    # move pstr to be the 1st argument
        movq    %r14,%rsi
        movq    %r15,%rdx
        call    replaceChar
        movq    %rax, %r12

        # replaceChar for the second pstr
        movq    $0, %rax            # initalize before get into function
        movq	%r13, %rdi		    # move pstr2 to be the 1st argument
        movq 	%r14,%rsi
        movq 	%r15,%rdx
        call	replaceChar
        movq    %rax, %r13

        # print the replaced strings
        movq  	%r14, %rsi
        movq    %r15, %rdx
        movq  	%r12, %rcx
        leaq    1(%rcx), %rcx
        movq  	%r13, %r8
        leaq    1(%r8), %r8
        movq	$.format1, %rdi		# move string to the 1st argument
		movq	$0, %rax
        call	printf			    # print function

        # restore saved registers: r15,r14,r13,r12
        pop   	%r15
        pop   	%r14
        pop   	%r13
        pop   	%r12
	    jmp	    done                # end program

     # if the user input case 53:
     # gets from the user index i and index j
     # using pstrijcpy function to replace the substring pstr1[i..j] to the substring pstr2[i..j]
    case53:
        sub     $16, %rsp

        # push callee save r12, r13 to stack
        push	%r12
        push    %r13
        push	%r14
        push    %r15

        movq    %rsi,%r12   		# move 2nd argument (dst) to r12
        movq    %rdx,%r13   		# move 3rd argument (src) to r13

        # get index i- start point
        leaq    -8(%rbp),%rsi
        movq    $.scanf2, %rdi
        movq    $0, %rax            # initalize before get into function
        call    scanf
        movzbq  -8(%rbp), %r14

        # get index j- end point
        leaq    -16(%rbp),%rsi
        movq    $.scanf2, %rdi
        movq    $0, %rax            # initalize before get into function
        call    scanf
        movzbq  -16(%rbp), %r15

        movq    $0, %rax            # initalize before get into function
        movq 	%r12,%rdi
        movq 	%r13,%rsi
        movq 	%r14,%rdx
        movq 	%r15,%rcx
        call    pstrijcpy
        movq    %rax, %r12

        movq    %r12, %rdi          # store address of Pstring
        movq    $0, %rax            # zero for safety
        call    pstrlen
        movq    %rax, %r14

        movq    %r13, %rdi          # store address of Pstring
        movq    $0, %rax            # zero for safety
        call    pstrlen
        movq    %rax, %r15

        # print the dst Pstring
        movq  	%r12, %rdx
        leaq    1(%rdx), %rdx
        movq    %r14, %rsi
        movq	$.format2, %rdi
		movq	$0, %rax
        call	printf

        # print the src Pstring
        movq   %r13, %rdx
        leaq    1(%rdx), %rdx
        movq   %r15, %rsi
        movq	$.format2, %rdi
		movq	$0, %rax
        call	printf

        # restore saved registers: r15,r14,r13,r12
        pop   	%r15
        pop   	%r14
        pop   	%r13
        pop   	%r12

	    jmp     done			# end program
     # if the user input case 54:
     # gets 2 strings and using the function swapCase
     # replaces each lower letter with a capital letter, and each capital letter with lower letter.
    case54:
        push	%r12			# push callee save r12, r13, r14, r15 to stack
        push 	%r13
        push 	%r14
        push 	%r15
        movq  	%rsi,%r12       # move 2nd argument (pstr1) to r12
        movq  	%rdx,%r13       # move 3rd argument (pstr2) to r13

        # swap pstr1
        movq	%r12, %rdi		# move pstr1 to rdi to send to the function
        movq    $0, %rax        # initalize before get into function
        call	swapCase		# send to function that return an address to pstring after change the char
        movq    %rax, %r12

        # print the swaped pstr1
        # get it's length
        movq    %r12, %rdi      # store address of Pstring
        movq    $0, %rax        # zero for safety
        call    pstrlen
        movq    %rax, %r14

        movq  	%r14, %rsi
        movq    %r12, %rdx
        leaq    1(%rdx), %rdx
        movl	$.format4, %edi # move string to parameter first
        movq	$0, %rax        # initalize before get into function
        call	printf

        # swap pstr2
        movq	%r13, %rdi		# move pstring2 to rdi to send to the function
        movq    $0, %rax        # initalize before get into function
        call	swapCase		# send to function that return an address to pstring after change the char
        movq    %rax, %r13

        # print the swaped pstr2
        # get it's length
        movq    %r13, %rdi      # store address of Pstring
        movq    $0, %rax        # zero for safety
        call    pstrlen
        movq    %rax, %r15

        movq  	%r15, %rsi
        movq    %r13, %rdx
        leaq    1(%rdx), %rdx
        movl	$.format4, %edi # move string to parameter first
        movq	$0, %rax        # initalize before get into function
        call	printf          # print function

        # restore saved registers: r15,r14,r13,r12
        pop   	%r15
        pop   	%r14
        pop   	%r13
        pop   	%r12

        jmp	done			    # end program

    # if the user input case 55:
    # the case gets 2 strings and using the function pstrijcmp to
    # compare the strings.
    case55:
        sub     $16, %rsp

        # push callee save r12/r13/r14/r15 to stack
        push    %r12
        push    %r13
        push    %r14
        push    %r15
        movq    %rsi,%r12   		# move 2nd argument (pstr1) to r12
        movq    %rdx,%r13           # move 3rdd argument (pstr2) to r13

        # get index i- start point
        leaq    -8(%rbp),%rsi
        movq    $.scanf2, %rdi
        movq    $0, %rax            # initalize before get into function
        call    scanf
        movzbq  -8(%rbp), %r14

        # get index j- end point
        leaq    -16(%rbp),%rsi
        movq    $.scanf2, %rdi
        movq    $0, %rax            # initalize before get into function
        call    scanf
        movzbq  -16(%rbp), %r15

        # call to pstrijcmp
        movq    $0, %rax            # initalize before get into function
        movq 	%r12, %rdi
        movq 	%r13, %rsi
        movq 	%r14, %rdx
        movq 	%r15, %rcx
        call    pstrijcmp

        # print the requested format
        movq  	%rax, %rsi
        movl	$.format5, %edi
        movq	$0, %rax		    # initalize before get into function
        call	printf

        # restore saved registers: r15,r14,r13,r12
        pop   	%r15
        pop   	%r14
        pop   	%r13
        pop   	%r12

	    jmp	done			        # end program

	# if the user input case 60:
    # gets two Pstrinngs and prints their length
    # using the function pstrlen
	case60:
        jmp	case50

    # if the user input case diffrent from 50/52/53/54/55/60
    # print an appropriate message
    caseDefault:
	    movl	$.formatError, %edi	# move string to the 1st argument
	    movq	$0, %rax
	    call	printf

	# finish the program
	done:
    	movq    %rbp, %rsp
    	popq	%rbp
    	ret
