
.section    .rodata
    input_int:      .string "%hhu"
    input_string:      .string "%s\0"
    input_char:     .string "%c"

    
.text
.global main
    .type   main, @function
main:
    pushq   %rbp        #save the old frame pointer 
    movq    %rsp,%rbp   #create the new frame pointer

    #beckup for callee register
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15
    pushq   %rbx

    # get first input size                
    subq    $1,%rsp             #increase the size of the stack in size of int     
    movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
    movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                #the stack where we write the value
    movq    $0,%rax             #set rax to zero 
    call scanf                  #call scanf function 

        
    # increase the rsp
    movb    (%rsp),%r12b       #save the size of the first string
    movzbq  %r12b,%r12         #zero extend         
    subq    %r12,%rsp          #increase the size of the stack according to the
                               #size of the first string

                    
    #get first input string
    movq    %rsp,%rsi               #set register rsi to point where rsp point at the 
                                    #stack to write the string                                                                      
    movq    $input_string,%rdi      #the firast argumant of scanf function is rdi       
    movq    $0,%rax                 #set rax to zero     
    call scanf                      #call scanf function

    #save the adress of the first string in r10 register
    movq    %rsp,%rbx
    
    #put the string size after the string
    subq    $1,%rsp             #increase the size of the stack in size of int
    movb    %r12b,(%rsp)        #save r12 in rsp
       
    
    # get second input size                
    subq    $1,%rsp             #increase the size of the stack in size of int     
    movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
    movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                #the stack where we write the value
    movq    $0,%rax             #set rax to zero 
    call scanf                  #call scanf function 

        
    # increase the rsp
    movb    (%rsp),%r13b       #save the size of the first string
    movzbq  %r13b,%r13         #zero extend 
    subq    %r13,%rsp          #increase the size of the stack according to the
                               #size of the first string

                    
    #get second input string
    movq    %rsp,%rsi               #set register rsi to point where rsp point at the 
                                    #stack to write the string                                                                      
    movq    $input_string,%rdi      #the firast argumant of scanf function is rdi       
    movq    $0,%rax                 #set rax to zero     
    call scanf                      #call scanf function

    #save the adress of the first string in r11 register
    movq    %rsp,%r15

    #put the string size after the string
    subq    $1,%rsp             #increase the size of the stack in size of int
    movb    %r13b,(%rsp)        #save r13 in rsp
    
     # get option value              
    subq    $1,%rsp             #increase the size of the stack in size of int     
    movq    $input_int,%rdi     #the firast argumant of scanf function is rdi    
    movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                #the stack where we write the value
    movq    $0,%rax             #set rax to zero 
    call scanf                  #call scanf function 
    
    movb    (%rsp),%r14b        #save the size of the first string
    movzbq  %r14b,%r14          #zero extend 
        
    # dummy              
    subq    $1,%rsp             #increase the size of the stack in size of int     
    movq    $input_char,%rdi    #the firast argumant of scanf function is rdi    
    movq    %rsp,%rsi           #the second argumant is a pointer to the location on                         
                                #the stack where we write the value
    movq    $0,%rax             #set rax to zero 
    call scanf                  #call scanf function
    addq    $1,%rsp             #increase the size of the stack in size of int
                    
    call run_func               #call run func - function                     
    
    #restoring callee registers                                                        
    popq   %r12
    popq   %r13
    popq   %r14
    popq   %r15
    popq   %rbx
    
    movq    $0,%rax             #set rax to zero
    movq    %rbp,%rsp           #free stack frame memory
    popq    %rbp                #restore %rbp
    ret
    