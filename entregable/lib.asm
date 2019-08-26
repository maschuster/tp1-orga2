
section .rodata
null: db 'NULL', 0

section .text

extern malloc
extern free
extern fprintf

global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global hashTableNew
global hashTableAdd
global hashTableDeleteSlot
global hashTableDelete




;/////////////////////////////////////////////////////STRING////////////////////////////////////////////////////////////////////

strLen:
        xor rax, rax    ;registro contador
.ciclo: mov cl, [rdi + rax]
        cmp cl, 0       ;comparo con 0
        je .fin
        inc rax         ;incremento contador
        jmp .ciclo
.fin:   ret





strClone:
    push rbp
    mov rbp, rsp

    call strLen
    mov rcx, rax ;longitud string
    mov rdx, rdi ;inicio string parámetro
    
    mov rdi, rax
    inc rdi
    push rcx
    push rdx
    call malloc
    pop rdx
    pop rcx

    xor r8, r8
    cmp [rdx], byte 0
    je .fin
.ciclo:
    mov dil, [rdx + r8]
    mov [rax + r8], dil
    inc r8
    cmp [rdx + r8], byte 0
    jne .ciclo
.fin:    
    mov [rax + r8], byte 0
    pop rbp
    ret





strCmp:
.ciclo:
    mov cl, [rdi]
    mov dl, [rsi]
    sub cl, dl
    jg .ganaA
    jl .ganaB
    cmp [rdi], byte 0
    je .terminaA
    cmp [rsi], byte 0
    je .terminaB
    inc rdi
    inc rsi
    jmp .ciclo
.terminaA:
    cmp [rsi], byte 0
    je .empate
    jmp .ganaB
.terminaB:
    cmp [rdi], byte 0
    je .empate
    jmp .ganaA
.ganaA:
    mov rax, -1
    jmp .fin
.ganaB:
    mov rax, 1
    jmp .fin
.empate:
    mov rax, 0
.fin:    
    ret




strConcat:
    push rbp
    mov rbp, rsp

    call strLen
    mov rcx, rax    ;longitud stringA
    mov rdx, rdi
    mov rdi, rsi    ;posición stringB
    mov rsi, rdx    ;posicion stringA
    push rcx
    call strLen
    pop rcx
    mov rdx, rax    ;longitud stringB
    add rax, rcx    ;tamaño nuevo string
    inc rax         ;tamaño nuevo string

    push rdi
    push rsi
    push rcx
    push rdx
    mov rdi, rax
    call malloc     ;rax tiene la posición de inicio de nuevo string
    pop rdx         ;longitud stringB
    pop rcx         ;longitud stringA
    pop rsi         ;posicion stringA
    pop rdi         ;posicion stringB

    xor r9, r9
.cicloA:
    mov r10b, [rsi + r9]
    mov [rax + r9], r10b       ;indexo con el contador y el puntero de inicio de string
    inc r9
    cmp [rsi + r9], byte 0     ;verifico si terminó el string 
    jne .cicloA

    xor r9, r9                 ;reinicio el contador
.cicloB:
    mov r10b, [rdi + r9]
    mov [rax + rcx], r10b      ;indexo con el tamaño del stringA y el contador
    inc r9
    inc rcx
    cmp [rdi + r9], byte 0     ;verifico si terminó el string
    jne .cicloB

    mov [rax + rcx], byte 0    ;termino el string
    push rax
    push rsi
    call free                  ;libero memoria stringA
    pop rdi
    push rcx
    call free                  ;libero memoria stringB
    pop rcx
    pop rax
    pop rbp
    ret





strDelete:
    call free
    ret
 



strPrint:
    push rbp
    mov rbp, rsp
    call strLen
    mov rdx, rdi
    mov rdi, rsi
    xor rsi, rsi
    cmp rax, 0
    je .esNull
.noEsNull:
    mov rsi, rdx
    call fprintf
    jmp .fin
.esNull:
    mov rsi, null
    call fprintf
.fin:
    pop rbp
    ret




;/////////////////////////////////////////////////////LISTAS////////////////////////////////////////////////////////////////////

listNew:
    ret

listAddFirst:
    ret

listAddLast:
    ret

listAdd:
    ret

listRemove:
    ret

listRemoveFirst:
    ret

listRemoveLast:
    ret

listDelete:
    ret

listPrint:
    ret



;/////////////////////////////////////////////////////HASH////////////////////////////////////////////////////////////////////


hashTableNew:
    ret

hashTableAdd:
    ret
    
hashTableDeleteSlot:
    ret

hashTableDelete:
    ret
