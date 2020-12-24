// Amber Weiner 208783522
    .data
    .section    .rodata

getString: .string " %s"
getInts: .string " %hhu"

    .text
.globl run_main
    .type   run_main,  @function

# Main function gets from the user two strings, lengths and operation option.
run_main:
     pushq   %rbp                # save old frame pointer
     movq    %rsp, %rbp

    # backup the calle registers
    pushq   %r12
    pushq   %r13

    # set place for two strings
    addq    $-512, %rsp

    # get from the user an integer (the first string's length)
    leaq    256(%rsp), %rsi
    movq    $getInts, %rdi                     # get the first string size
    movq    $0, %rax                           # Reset %rax
    call    scanf
    movq    256(%rsp), %r12

    # get from the user the first string
    leaq    257(%rsp), %rsi                    # store the string adress in %rsi
    movq    $0, %rax                           # reset %rax to 0
    movq    $getString, %rdi                   # put the scanf pattern in %rdi
    call    scanf
    movb   %r12b, 256(%rsp)

    # get from the user an integer (the second string's length)
    movq    %rsp, %rsi
    movq    $getInts, %rdi                     # get the first string size
    movq    $0, %rax                           # Reset %rax
    call    scanf
    movq    (%rsp), %r13

    # get from the user the first string
    leaq    1(%rsp), %rsi                    # store the string adress in %rsi
    movq    $0, %rax                           # reset %rax to 0
    movq    $getString, %rdi                   # put the scanf pattern in %rdi
    call    scanf
    movb   %r13b, (%rsp)

    # get the option input
    movq    $getInts, %rdi                     # put the string pattern in %rdi
    movq    $0, %rax                           # reset %rax
    addq    $-16, %rsp                          # allocate 4 bytes for the string size
    leaq    (%rsp), %rsi
    call    scanf
    movq    (%rsp), %rdi                       # move the string size to %r8
    addq    $16, %rsp                           # free the memory

    # store the input arguments in the run_option function arguments.
    leaq    256(%rsp), %rsi
    movq    %rsp, %rdx
    movq    $0, %rax                           # reset %rax
    call    run_func

    # restore the calle registers
    popq    %r13
    popq    %r12

    movq    %rbp, %rsp          # restore old frame pointer
    popq    %rbp
    ret

