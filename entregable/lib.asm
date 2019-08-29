
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
    mov rcx, rax    ;longitud string
    mov rdx, rdi    ;inicio string parámetro
    
    mov rdi, rax    ;longitud string
    inc rdi         ;longitud nuevo string contando el 0 del final
    push rcx        ;guardo longitud string
    push rdx        ;guardo inicio string parámetro
    call malloc
    pop rdx
    pop rcx

    xor r8, r8      ;inicializo contador
    cmp [rdx], byte 0;chequeo si la longitud es 0
    je .fin         ;si la long es 0 voy al fin
.ciclo:
    mov dil, [rdx + r8]     ;guardo letra temporalmente
    mov [rax + r8], dil     ;escribo la letra en el nuevo string
    inc r8                  ;incremnto contador
    cmp [rdx + r8], byte 0  ;reviso si terminé de recorrer el string
    jne .ciclo
.fin:    
    mov [rax + r8], byte 0  ;si vengo del salto, pongo un 0 en la posición del malloc pedida. Si vengo del ciclo solo pongo 0 al final.
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
    pop rcx         ;longitud stringA
    mov rdx, rax    ;longitud stringB
    add rax, rcx    ;tamaño nuevo string
    inc rax         ;tamaño nuevo string para pedir memoria

    push rdi
    push rsi
    push rcx
    push rdx
    mov rdi, rax
    call malloc     ;rax tiene la posición de inicio de nuevo string
    pop rdx         ;longitud stringB
    pop rcx         ;longitud stringA
    pop rsi         ;posicion stringA
    mov rdi, rax    ;pongo en rdi la posición donde quiero poner stringA y luego concatenar stringB
    call strCopyFromTo  ;copioStringA
    mov r8, rsi     ;posicion stringA
    pop rsi         ;posicion stringB
    add rdi, rcx    ;agrego offset de stringA
    call strCopyFromTo  ;copioStringB
    sub rdi, rcx    ;quito offset stringA
    add rcx, rdx    ;agrego longitud stringB
    mov [rax + rcx], byte 0    ;termino el string

    mov rax, rdi    ;posicion nuevo string
    cmp rsi, r8     ;comparo posiciones stringB y stringA
    je .Iguales
.liberoAmbos:
    push rax
    push rsi
    mov rdi, r8     ;posicion stringA a liberar
    call free
    pop rdi         ;posicion stringB a liberar
    sub rsp, 8      ;alineo pila
    call free
    add rsp, 8      ;alineo pila
    pop rax         ;inicio nuevo string
    jmp .fin
.Iguales:
    push rax        ;guardo posicion nuevo string
    sub rsp, 8      ;alineo pila
    mov rdi, rsi    ;posicion stringA = posicion stringB
    call free
    add rsp, 8      ;alineo pila
    pop rax
.fin:
    pop rbp
    ret



strCopyFromTo:
    ;RDI HACIA DONDE COPIO
    ;RSI DESDE DONDE COPIO
    xor r9, r9
.ciclo:
    cmp [rsi + r9], byte 0     ;verifico si terminó el string 
    je .fin
    mov r10b, [rsi + r9]
    mov [rdi + r9], r10b       ;indexo con el contador y el puntero de inicio de string
    inc r9
    jmp .ciclo
.fin:
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
