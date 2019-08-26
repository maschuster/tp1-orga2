
section .rodata
ch0 db 0
null: db "NULL"

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

strLen:
        xor rax, rax    ;registro contador
.ciclo: mov cl, [rdi + rax*1]
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

.ciclo:
    mov dil, [rdx + r8]
    mov [rax + r8], dil
    inc r8
    cmp [rdx + r8], byte 0
    jne .ciclo
    mov [rax +r8], byte 0
    pop rbp
    ret

strCmp:
    ret

strConcat:
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







hashTableNew:
    ret

hashTableAdd:
    ret
    
hashTableDeleteSlot:
    ret

hashTableDelete:
    ret
