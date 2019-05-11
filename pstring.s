
.section    .rodata 
    invalid:     .string "invalid  input!\n"
   
.text
.global pstrln
    .type   pstrln, @function
pstrln:
    xorq    %rax,%rax   #set rax to zero
    subq    $1,%rdi     #rdi hold a pointer to the string,
                        #we need to incerase in 1 to get the length
    movb    (%rdi),%al  #put rdi in rax- the value return
    movzbq  %al,%rax    #zero extend 
    ret                                            

.global replaceChar
    .type   replaceChar, @function
replaceChar:
    movq    %rdi,%rax           #rax= adress to the string 
    
    movq    $0,%r8              #save '\0'
    cmpb    -1(%rdi),%r8b       #check if the length=0
    je  .end_loop               
    
    .loop:
        movb    (%rdi),%r9b     #svae current char to r9
        cmpb    %r9b,%dl        #check if r9=old char
        je .replace
        .add:
            addq    $1,%rdi     #increment the pointer of the string 
        cmpb    (%rdi),%r8b     #check if the currunt char='\0'
        je  .end_loop
        jne .loop
    .replace:
        movb    %cl,(%rdi)      #replace old char with new char
        jmp     .add            #continue loop     
        
    .end_loop:
        ret   

.global pstrijcpy
    .type   pstrijcpy, @function           
pstrijcpy:
    movq    %rdi,%rax        #save rdi in rax - return       
    movq    $0,%r8           #r8=0
    xorq    %r9,%r9          #set r9 to zero
    xorq    %r10,%r10        #set r10 to zero
    movb    -1(%rdi),%r9b    #save the length of the first string in r9
    movb    -1(%rsi),%r10b   #save the length of the first string in r10
    
    #i>=0
    cmpq    %r8,%rdx
    jl .invalid
    
    #j>str1
    cmpq    %rcx,%r9
    jle .invalid      
    
    #j>=str2
    cmpq    %rcx,%r10
    jle .invalid       
    
    #i<=j
    cmpq    %rdx,%rcx
    jl .invalid
    
    addq    %rdx,%rdi           #str1=str1+i
    addq    %rdx,%rsi           #str2=str2+i
       
    #loop: i<=j
    .loop_copy:
        # str1[i]=str2[i]
        movb    (%rsi),%r8b     #save str2[i] to r8
        movb    %r8b,(%rdi)     #save r8 to str1[i]
        
        addq    $1,%rdx         #i++
        addq    $1,%rdi         #str1++
        addq    $1,%rsi         #str2++
         
        #i<=j
        cmpq    %rdx,%rcx
        jge     .loop_copy
        jl      .end                                                                                                              
                                                                                                                        
    .invalid:
        movq    $invalid,%rdi     #the firast argumant of scanf function is rdi
        xorq    %rax,%rax         #set rax to zero
        call printf
        movq    $0,%rax        #save rdi in rax - return       
      
    .end:
        ret           
 
.global swapCase
    .type   swapCase, @function
swapCase:
    movq    %rdi,%rax           #rax= adress to the string 
    xorq    %r9,%r9             #set r9 to zero
    movq    $0,%r8              #save '\0'
    cmpb    -1(%rdi),%r8b       #check if the length=0
    je  .end_loop_swap               
    
    .loop_swap:
        #check capital
        movb    (%rdi),%r9b     #svae current char to r9
        cmpq    $65,%r9         #check if r9<65
        jl .inc
        cmpq    $90,%r9         #check if r9>90
        jg  .check_small_letter  
        
        #big to small
        addb    $32,%r9b
        movb    %r9b,(%rdi)
        jmp .inc
        
        
        .check_small_letter:
            cmpq    $97,%r9         #check if r9<a
            jl .inc
            cmpq     $122,%r9       #check if r9>z
            jg  .inc
            subb    $32,%r9b
            movb    %r9b,(%rdi)
           
                             
        .inc:
            addq    $1,%rdi     #increment the pointer of the string 
        cmpb    (%rdi),%r8b     #check if the currunt char='\0'
        je  .end_loop_swap
        jne .loop_swap
   
     .replace_char:
        movb    %cl,(%rdi)      #replace old char with new char
        jmp     .add            #continue loop     
        
    .end_loop_swap:
        ret       
  
.global pstrijcmp
    .type   pstrijcmp, @function  
pstrijcmp:           
    movq    $0,%r8           #r8=0
    xorq    %r9,%r9
    xorq    %r10,%r10
    movb    -1(%rdi),%r9b    #save the length of the first string in r9
    movb    -1(%rsi),%r10b   #save the length of the first string in r10
    
    #i>=0
    cmpq    %r8,%rdx
    jl .invalid_i_j
    
    #j>str1
    cmpq    %rcx,%r9
    jle .invalid_i_j      
    
    #j>=str2
    cmpq    %rcx,%r10
    jle .invalid_i_j       
    
    #i<=j
    cmpq    %rdx,%rcx
    jl .invalid_i_j
    
    addq    %rdx,%rdi           #str1=str1+i
    addq    %rdx,%rsi           #str2=str2+i
       
    #loop: i<=j
    .while_loop:
        xorq    %r9,%r9
        xorq    %r10,%r10
        
        movb    (%rsi),%r9b     #save str2[i] to r9
        movb    (%rdi),%r10b    #save str2[i] to r10
        
        cmpb    %r9b,%r10b
        jg      .smaller
        jl      .bigger
        
        
        addq    $1,%rdx         #i++
        addq    $1,%rdi         #str1++
        addq    $1,%rsi         #str2++
         
        #i<=j
        cmpq    %rdx,%rcx
        jge     .while_loop
        jl      .end_while                                                                                                              
    
     #sr1<str2 
    .smaller:
        movq    $1,%rax
        ret
    
     #sr1>str2        
    .bigger:
        movq    $-1,%rax
        ret  
  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    .invalid_i_j:
        movq    $invalid,%rdi     #the firast argumant of scanf function is rdi
        xorq    %rax,%rax         #set rax to zero
        call printf
        movq    $-2,%rax          #save rdi in rax - return   
        ret    
      
    .end_while:
        movq    $0,%rax           #set rax to zero
        ret  
                       
        