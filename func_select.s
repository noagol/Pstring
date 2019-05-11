
.section    .rodata
    input_int:      .string "%hhu"
    input_string:      .string "%s\0"
    input_char:     .string "%c"
    default:     .string "invalid  option!\n"
    invalid:     .string "invalid  input!\n"
    case50_printf:  .string "first pstring length: %d, second pstring length: %d\n"
    case51_printf:  .string "old char: %c, new char: %c, first string: %s, second string: %s\n" 
    case52_printf:  .string "length: %d, string: %s\n"  
    case54_printf:  .string "compare result: %d\n"  

    
    .align 8  # Align address to multiple of 8
    .options:
    .quad .case50 
    .quad .case51 
    .quad .case52 
    .quad .case53 
    .quad .case54 
    .quad .default 

        
.text
.global run_func
    .type   run_func, @function
run_func:
     
    pushq   %rbp        #save the old frame pointer 
    movq    %rsp,%rbp   #create the new frame pointer
    
    #beckup for callee register
    pushq   %r14
    pushq   %r15
    pushq   %rbx
            
    # Set up the jump table access
    leaq -50(%r14),%rsi             # Compute xi = x-50
    cmpq $4,%rsi                    # Compare xi:4
    ja .default                     # if >, goto default-case
    jmp *.options(,%rsi,8)          # Goto jt[xi]
    
    
    # Case 50 - user option
    .case50:                       
        xorq    %rax,%rax       #set rax to zero 
        movq    %rbx,%rdi       #set first argumant of pstrln to be the pointer 
                                #to the first string 
        call pstrln
        
        movq    %rax,%rsi       #save the first length of the string 
                                #in the first argumant of printf
        xorq    %rax,%rax       #set rax to zero 
        
        movq    %r15,%rdi        #set second argumant of pstrln to be the pointer 
                                 #to the first string
        call pstrln
        
        movq    %rax,%rdx       #save the second length of the string 
                                #in the second argumant of printf
        
        movq    $case50_printf,%rdi     #the firast argumant of scanf function is rdi
        
        xorq    %rax,%rax       #set rax to zero
        
        call printf                                                                                                                                                                                                             
        
        jmp .done                   # Goto done
        
     # Case 51 - user option   
    .case51:
        #scanf old char                       
        subq    $1,%rsp             #increse the stack in 1
        movq    $input_char,%rdi    #the firast argumant of scanf function is rdi
        movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                    #the stack where we write the value
        xorq    %rax,%rax           #set rax to zero
        call    scanf
        
        #dummy for space 
        subq    $1,%rsp             #increse the stack in 1
        movq    $input_char,%rdi    #the firast argumant of scanf function is rdi
        movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                    #the stack where we write the value
        xorq    %rax,%rax           #set rax to zero
        call    scanf
        addq    $1,%rsp
        
        #scanf new char
        subq    $1,%rsp              #increse the stack in 1
        movq    $input_char,%rdi     #the firast argumant of scanf function is rdi
        movq    %rsp,%rsi            #the second argumant is a pointer to the location on                         
                                     #the stack where we write the value
        xorq    %rax,%rax            #set rax to zero
        call    scanf
        
        movq    %rbx,%rdi           #set first argumant of replaceChar to be the pointer 
                                    #to the first string 
      
        xorq    %rdx,%rdx           #set rdx to zero
        xorq    %rcx,%rcx           #set rcx to zero
        
        movb    1(%rsp),%dl         #save old char in rdx
        movb    (%rsp),%cl          #save new char in rcx
        
        addq    $2,%rsp             #return rsp to top of the stack
        
        call    replaceChar         #replace char in first string
       
        #replace char in second string
        movq    %r15,%rdi       #set first argumant of replaceChar to be the pointer 
                                #to the first string 
        call    replaceChar

        xorq    %rdi,%rdi        
        movq    %rdx,%rsi       #save old char
        movq    %rcx,%rdx       #save new char
        movq    %rbx,%rcx       #save fitst string
        movq    %r15,%r8        #save second string
       
        movq    $case51_printf,%rdi     #the firast argumant of scanf function is rdi
        
        xorq    %rax,%rax       #set rax to zero
        
        call printf             #prunt the val in rsp
        
        
        jmp .done
    
    # Case 52 - user option
    .case52:
        #get i
        subq    $1,%rsp             #increase the size of the stack in size of int     
        movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
        movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                    #the stack where we write the value
        movq    $0,%rax             #set rax to zero 
        call scanf                  #call scanf function 
        
        #get j
        subq    $1,%rsp             #increase the size of the stack in size of int     
        movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
        movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                    #the stack where we write the value
        movq    $0,%rax             #set rax to zero 
        call scanf                  #call scanf function 
        
        #param to pstrijcmp
        xorq    %rsi,%rsi           #set rsu to zero 
        xorq    %rdx, %rdx          #set rdx to zero 
        xorq    %rcx, %rcx          #set rcx to zero 
        movb    1(%rsp),%dl         #save i in rdx
        movb    (%rsp),%cl          #save j in rcx
        movq    %rbx,%rdi           #set first argumant of pstrijcpy to be the pointer 
                                    #to the first string 
        movq    %r15,%rsi           #set second argumant of pstrijcpy to be the pointer 
                                    #to the first string
        addq    $2,%rsp             #return rsp to top of the stack
        
        call  pstrijcpy
        
        #print first string
        movq    %rbx,%rdx               #save pointer to rbx in rdx
        xor     %r8,%r8                 #set r8 to zero
        movb    -1(%rbx),%r8b           #save the length of str1 in r8   
        xorq    %rsi,%rsi               #set rsi to zero
        movq    %r8,%rsi                #save the length to rsi
        movq    $case52_printf,%rdi     #the first argumant of scanf function is rdi        
        xorq    %rax,%rax               #set rax to zero        
        call printf                     #print the val in rsp
        
        #print second string
        movq    %r15,%rdx               #save pointer to rbx in rdx
        xor     %r8,%r8                 #set r8 to zero
        movb    -1(%r15),%r8b           #save the length of str2 in r8
        xorq    %rsi,%rsi               #set rsi to zero
        movq    %r8,%rsi                #save the length to rsi
        movq    $case52_printf,%rdi     #the first argumant of scanf function is rdi        
        xorq    %rax,%rax               #set rax to zero        
        call printf                     #print the val in rsp            
                                                                                                                                                                                                                                                                                                                                                                                                      
        jmp .done

    # Case 53 - user option
    .case53:
             
        #sawp first string
        movq    %rbx,%rdi               #save rbx to rdi
        call swapCase
       
        #swap second string
        movq    %r15,%rdi               #save r15 to rdi
        call swapCase
        
       #print first string
        movq    %rbx,%rdx               #save pointer to rbx in rdx
        xor     %r8,%r8                 #set r8 to zero
        movb    -1(%rbx),%r8b           #save the length of str1 in r8   
        xorq    %rsi,%rsi               #set rsi to zero
        movq    %r8,%rsi                #save the length to rsi
        movq    $case52_printf,%rdi     #the first argumant of scanf function is rdi        
        xorq    %rax,%rax               #set rax to zero        
        call printf                     #print the val in rsp
        
        #print second string
        movq    %r15,%rdx               #save pointer to rbx in rdx
        xor     %r8,%r8                 #set r8 to zero
        movb    -1(%r15),%r8b           #save the length of str2 in r8
        xorq    %rsi,%rsi               #set rsi to zero
        movq    %r8,%rsi                #save the length to rsi
        movq    $case52_printf,%rdi     #the first argumant of scanf function is rdi        
        xorq    %rax,%rax               #set rax to zero        
        call printf                     #print the val in rsp
        
        
        jmp .done
    
    # Case 54 - user option
    .case54:
        #get i
        subq    $1,%rsp             #increase the size of the stack in size of int     
        movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
        movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                    #the stack where we write the value
        movq    $0,%rax             #set rax to zero 
        call scanf                  #call scanf function 
        
        #get j
        subq    $1,%rsp             #increase the size of the stack in size of int     
        movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
        movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                    #the stack where we write the value
        movq    $0,%rax             #set rax to zero 
        call scanf                  #call scanf function 
        
        #param to pstrijcmp
        xorq    %rsi,%rsi           #set rsi to zero
        xorq    %rdx, %rdx          #set rdx to zero
        xorq    %rcx, %rcx          #set rcx to zero
        movb    1(%rsp),%dl         #save i in rdx
        movb    (%rsp),%cl          #save j in rcx
        movq    %rbx,%rdi           #set first argumant of pstrijcpy to be the pointer 
                                    #to the first string 
        movq    %r15,%rsi           #set second argumant of pstrijcpy to be the pointer 
                                    #to the first string
        addq    $2,%rsp             #return rsp to top of the stack
        
        call  pstrijcmp
        
        #print cmp   
        xorq    %rsi,%rsi               #set rsi to zero
        movq    %rax,%rsi                #save the length to rsi
        movq    $case54_printf,%rdi     #the first argumant of scanf function is rdi        
        xorq    %rax,%rax               #set rax to zero        
        call printf                     #print the val in rsp      
        
        jmp .done
    
    
    .default:
        movq    $default,%rdi   #first argumant- format of printf
        xorq    %rax,%rax       #set rda to zero
        call printf
    
    
    
    .done:
        #restoring callee registers
        popq   %r14
        popq   %r15
        popq   %rbx
        
        movq    $0,%rax         #set rax to zero
        movq    %rbp,%rsp       #free stack frame memory
        popq    %rbp            #restore %rbp
        ret
        