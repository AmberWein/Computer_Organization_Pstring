// Amber Weiner 208783522
 .section  .rodata

# string formats
.formatError:    .string "invalid input!\n"

    .section  .text
# pstrlen- The function gets Pstring and return its length.
.globl pstrlen
    .type pstrlen, @function
pstrlen:
        pushq   %rbp                # save old frame pointer
        movq    %rsp, %rbp

        movq    $0, %rax            # zero for safety
        movzbq  (%rdi), %rax        # move first byte (the size of the Pstring) to %rax

        movq    %rbp, %rsp          # restore old frame pointer
        popq    %rbp
        ret

# replaceChar - the function gets 3 parameters: address of Pstring, old char and new char
# replace every old char in the Pstring with a new char.
.globl replaceChar
    .type replaceChar, @function
replaceChar:
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12                # store callie save register

    movq    %rdi, %r12          # store address of Pstring
    movq    $0, %rax            # zero for safety
    call    pstrlen             # Pstring address is already in %rdi
    movq    %rax, %rcx          # store Pstring length
    movq    $0, %r8 		    # r8 is counter of for loop
    incq    %rdi

    jmp	.forLoop1

    # a for loop to go over each char in the given Pstring
    .forLoop1:
        # compare i to string length
    	 cmpq   %r8, %rcx
         je     .end                    # case i = Pstring.length

         cmpb   (%rdi), %sil            # if string[i] == oldchar
         je     .incSwapCase

         # increase with no swap
         addq   $1, %rdi
         addq   $1, %r8                # i++
         jmp    .forLoop1

    .incSwapCase: # increase with swap
        movb    %dl, (%rdi)
    	addq    $1, %rdi
        addq    $1, %r8                # i++
        jmp     .forLoop1

    .end:
        movq    %r12, %rax          # return Pstring address after change
        popq    %r12                # restore callie save register
        movq    %rbp, %rsp          # restore old frame pointer
        popq    %rbp
        ret

# pstrijcpy- gets 2 indexes and 2 addresses of Pstring
# and replace the substring pstr1[i,j] with pstr2[i,j].
# if the index cross the array bounds the function will print an error.
.globl pstrijcpy
    .type pstrijcpy, @function
pstrijcpy:
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp

    # store callie save register
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

    movq    %rdi, %r12          # store address of dst Pstring
    movq    %rsi, %r13          # store address of src Pstring
    movq    %rdx, %r14          # store i
    movq    %rcx, %r15          # store j

    # find the length of each string
    # for dst pstring
    movq    %r12, %rdi          # store address of Pstring
    movq    $0, %rax            # zero for safety
    call    pstrlen
    movq    %rax, %r8
    add     $-1, %r8

    # for src pstring
    movq    %r13, %rdi          # store address of Pstring
    movq    $0, %rax            # zero for safety
    call    pstrlen
    movq    %rax, %r9
    add     $-1, %r9

    # check validity for i and j
    # for i
    cmp     %r14, %r8
    jb      .invalidCse
    cmp     %r14, %r9
    jb      .invalidCse
    # for j
    cmp     %r15, %r8
    jb      .invalidCse
    cmp     %r15, %r9
    jb      .invalidCse
    # if i > j
    cmp     %r14, %r15
    jb      .invalidCse

    # set rdi to 1st string
    movq    %r12, %rdi
    incq    %rdi
    leaq    (%rdi,%r14), %rdi

    # set rsi to 2nd string
    movq    %r13, %rsi
    incq    %rsi
    leaq    (%rsi,%r14), %rsi

    movq    %rdx, %r8 		    # r8 is index for loop

    jmp     .forLoop2
    .invalidCse:
        movq	$.formatError, %rdi
        call	printf
        jmp     .end2
    .forLoop2:
        # compare i to j
    	 cmpq   %r14, %r15
         jb     .end2                # case i > j

        # swap
        movb    (%rsi), %cl
        movb    %cl, (%rdi)

        jmp    .inc

    .inc:
        incq    %rsi
    	incq    %rdi
        incq    %r14            # i++
        jmp     .forLoop2

    .end2:
        movq    %r12, %rax          # return dst pstring
        popq    %r15
        popq    %r14
        popq    %r13
        popq    %r12
        movq    %rbp, %rsp          # restore old frame pointer
        popq    %rbp
        ret
.globl swapCase
    .type swapCase, @function
swapCase:
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp

    # store callie save register
    pushq   %r12
    movq    %rdi, %r12          # store address of Pstring
    movq    $0, %rax            # zero for safety
    call    pstrlen             # Pstring address is already in %rdi
    movq    %rax, %rcx          # store Pstring length
    movq    $0, %r8 		    # r8 is counter of for loop

 # a for loop to go over each char in the given pstring
    .forLoop4:
        incq    %rdi
        # compare i to string length
    	 cmpq   %r8, %rcx
         je     .end4                   # case i == Pstring.length

         movb   (%rdi), %dl         # temp string[i]
         cmpb   $64, %dl            # if string[i]'s value is bigger than 64
         ja     .maybeLetter
         jmp    .inc4

    .maybeLetter:
        # check if big letter
        cmpb     $91, %dl
        jb      .toSmall
        # check if between 90-97
        cmpb     $97, %dl
        jb      .inc4
        # check if small letter
        cmpb     $123, %dl
        jb      .toBig
        jmp     .inc4
    .inc4:
         addq   $1, %r8                # i++
         jmp    .forLoop4
    .toBig:
        addb    $-32, (%rdi)
    	jmp    .inc4
    .toSmall:
        addb    $32, (%rdi)
    	jmp    .inc4

    .end4:
        movq    %r12, %rax          # return Pstring address after change
        movq    -8(%rbp), %r12      # restore callie save register
        movq    %rbp, %rsp          # restore old frame pointer
        popq    %rbp
        ret

# pstrijcmp - the function gets 2 Pstrings and 2 indexes i,j and compare
# by lexicographic order the substrings pstr1[i,j] with pstr2[i,j].
# if pstr1[i,j] is bigger- the function return 1
# if pstr2[i,j] is bigger- the function return -1
# if equal- the function return 0
# if the index cross the array bounds the function will print an error and return -2.
.globl pstrijcmp
    .type pstrijcmp, @function
pstrijcmp:
        pushq   %rbp                # save old frame pointer
        movq    %rsp, %rbp

        # store callie save register
        pushq   %r12
        pushq   %r13
        pushq   %r14
        pushq   %r15

        movq    %rdi, %r12          # store address of pstr1
        movq    %rsi, %r13          # store address of pstr2

        # find the first string's length
        movq    %r12, %rdi          # store address of pstr1
        movq    $0, %rax            # zero for safety
        call    pstrlen
        movq    %rax, %r14
        add     $-1, %r14

        # find the second string's length
        movq    %r13, %rdi          # store address of pstr2
        movq    $0, %rax            # zero for safety
        call    pstrlen
        movq    %rax, %r15
        add     $-1, %r15

        # check validity of i and j
        # for i
        cmp     %rdx, %r14
        jb      .invalidCse2
        cmp     %rdx, %r15
        jb      .invalidCse2
        # for j
        cmp     %rcx, %r14
        jb      .invalidCse2
        cmp     %rcx, %r15
        jb      .invalidCse2
        # case i > j
        cmp     %rdx, %rcx
        jb      .invalidCse2

        # set rdi to 1st pstring
        movq    %r12, %rdi
        incq    %rdi
        leaq    (%rdi,%rdx), %rdi

        # set rsi to 2nd pstring
        movq    %r13, %rsi
        incq    %rsi
        leaq    (%rsi,%rdx), %rsi

        movq    %rdx, %r8 		    # r8 is index for loop
        movq    $0, %rax
        jmp     .forLoop5
        .invalidCse2:
            movq	$.formatError, %rdi
            call	printf
            movq    $-2, %rax
            jmp     .end5

        # a for loop to go over each char in the given pstring
        .forLoop5:
            # compare i to string length
    	    cmpq   %r8, %rcx
            jb     .end5                    # case i = Pstring.length

            movb    (%rdi), %dl
            cmpb    (%rsi), %dl
            je      .inc5                   # if pstr1[i] == pstr[j]
            cmpb    (%rsi), %dl
            ja      .firstCase
            jmp     .secondCase
        .inc5:
            incq    %rdi
            incq    %rsi
            incq    %r8                # i++
            jmp    .forLoop5
        .firstCase:                    # if pstr1[i,j] is bigger
            movq    $1, %rax
            jmp     .end5
        .secondCase:                   # if pstr2[i,j] is bigger
            movq    $-1, %rax
            jmp     .end5
        .end5:
            popq    %r15
            popq    %r14
            popq    %r13
            popq    %r12
            movq    %rbp, %rsp          # restore old frame pointer
            popq    %rbp
            ret
