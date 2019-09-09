
section .rodata
null: db 'NULL', 0
dataPointer: db '%p', 0
printString: db '%s', 0
corcheteIzq: db '[', 0
corcheteDer: db ']', 0
comma: db ',' , 0

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

%define NULL 0
; OFFSET NODO
%define nodo_offset_dato 0
%define nodo_offset_next 8
%define nodo_offset_prev 16
; OFFSET LISTA
%define lista_offset_first 0
%define lista_offset_last 8
; TAMAÑO NODO
%define tam_nodo 24
; TAMAÑO LISTA
%define tam_lista 16

;Hash Table
%define hTable_offset_array 0
%define hTable_offset_size 8
%define hTable_offset_funHash 16
;tamaño hTable
%define tam_hash 24


;/////////////////////////////////////////////////////STRING////////////////////////////////////////////////////////////////////

strLen:
        xor rax, rax    ;registro contador
.ciclo: mov cl, [rdi + rax]
        cmp cl, 0       ;comparo con 0
        je .fin
        inc eax         ;incremento contador
        jmp .ciclo
.fin:   ret



strClone:
    push rbp
    mov rbp, rsp

    call strLen
    mov rdx, rdi    ;inicio string parámetro
    
    mov rdi, rax    ;longitud string
    inc rdi         ;longitud nuevo string contando el 0 del final
    sub rsp, 8
    push rdx        ;guardo inicio string parámetro
    call malloc
    pop rdx
    add rsp, 8

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
    mov dword eax, -1
    jmp .fin
.ganaB:
    mov dword eax, 1
    jmp .fin
.empate:
    mov dword eax, 0
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
    push rbp
    mov rbp, rsp

    call free
    pop rbp
    ret


strPrint:
    push rbp
    mov rbp, rsp
    call strLen
    mov rdx, rdi;   rdx <- char*
    mov rdi, rsi;   rdi <- pFile
    xor rsi, rsi
    mov rsi, printString;   rsi <- "%s"
    cmp qword rax, 0
    je .esNull
    jmp .fin
.esNull:
    mov rdx, null
.fin:
    call fprintf
    pop rbp
    ret




;/////////////////////////////////////////////////////LISTAS////////////////////////////////////////////////////////////////////

listNew:
    push rbp
    mov rbp, rsp

    mov rdi, tam_lista                      ;pido la memoria necesaria para una lista
    call malloc
    mov qword [rax + lista_offset_first], NULL    ;pongo el first en null
    mov qword [rax + lista_offset_last], NULL     ;pongo el last en null

    pop rbp
    ret



listAddFirst:
; 	rdi = lista* lista
; 	rsi = void* data
	push rbp
	mov rbp, rsp
	; preservo registros r12 y r13, ya que los voy a usar
	push r12
	push r13
	; tengo que guardar los valores de rdi y rsi ya que voy a llamar a malloc
	mov r12, rdi;   puntero a lista
	mov r13, rsi;   puntero a dato
	
	; pido memoria para un nuevo nodo
	mov rdi, tam_nodo
	call malloc

	; guardo los datos correspondientes al nuevo nodo
	mov [rax + nodo_offset_dato], r13;  pongo el puntero al dato 
    mov qword [rax + nodo_offset_prev], NULL; pongo NULL en anterior (pues es el primero)
	mov rdi, [r12+lista_offset_first];  guardo el puntero al primer elem

    cmp rdi, NULL; me fijo si la lista era vacía
    je .listaVacia
	mov [rax + nodo_offset_next], rdi;  pongo como próximo al antiguo primer elemento
    mov [rdi + nodo_offset_prev], rax;  pongo al nuevo nodo como predecesor del antiguo primero.
    mov [r12+lista_offset_first], rax;   apunto el first de la lista al nuevo nodo
    jmp .fin

    ; actualizo la información de la lista agregando como primer (y ultimo si es vacia) al nuevo nodo.
.listaVacia:
	mov [r12+lista_offset_first], rax;   apunto el first de la lista al nuevo nodo
    mov [r12+lista_offset_last], rax;    apunto el last de la lista al nuevo nodo
    mov qword [rax + nodo_offset_next], NULL; pongo NULL el siguiente (pues es vacia)
.fin:
	pop r13
	pop r12
	pop rbp
	ret


listAddLast:
; 	rdi = lista* lista
; 	rsi = void* data
	push rbp
	mov rbp, rsp
	; preservo registros r12 y r13, ya que los voy a usar
	push r12
	push r13
	; tengo que guardar los valores de rdi y rsi ya que voy a llamar a malloc
	mov r12, rdi;   puntero a lista
	mov r13, rsi;   puntero a dato
	
	; pido memoria para un nuevo nodo
	mov rdi, tam_nodo
	call malloc

	; guardo los datos correspondientes al nuevo nodo
	mov [rax + nodo_offset_dato], r13;  guardo el puntero al dato 
    mov qword [rax + nodo_offset_next], NULL; pongo NULL en siguiente (pues es el ultimo)
	mov rdi, [r12+lista_offset_last];  guardo el puntero al ultimo elem

    cmp rdi, NULL; me fijo si la lista era vacía
    je .listaVacia
	mov [rax + nodo_offset_prev], rdi;  pongo como anterior al antiguo ultimo elemento
    mov [rdi + nodo_offset_next], rax;  pongo al nuevo nodo como sucesor del antiguo ultimo.
    mov [r12+lista_offset_last], rax;   apunto el last de la lista al nuevo nodo
    jmp .fin

    ; actualizo la información de la lista agregando como ultimo (y primer si es vacia) al nuevo nodo.
.listaVacia:
	mov [r12+lista_offset_first], rax;   apunto el first de la lista al nuevo nodo
    mov [r12+lista_offset_last], rax;    apunto el last de la lista al nuevo nodo
    mov qword [rax + nodo_offset_prev], NULL; pongo NULL en anterior (pues es vacia)
.fin:
	pop r13
	pop r12
	pop rbp
	ret



listAdd:
    ;rdi <- lista*, 
    ;rsi <- data*
    ;rdx <- funcCmp*
    push rbp
	mov rbp, rsp

    push r12
    push r13
    push r14
    push r15
    push rbx

    mov r12, [rdi + lista_offset_first]; r12 <- nodoActual
    mov r13, rsi; data*
    mov r14, rdx; funCmp*
    lea r15, [rdi + lista_offset_first]; nodo**
    mov rbx, rdi; lista*

.recorrer:
    cmp qword r12, NULL
    je .agregarUltimo

    mov rsi, [r12 + nodo_offset_dato]; rdi <- dataNodo*
    mov rdi, r13; rsi <- data*
    sub rsp, 8;alineo pila
    call r14; llamo funCmp
    add rsp, 8;alineo pila
    cmp dword eax, 1; si el dato es más chico, lo agrego ?????? VER BIEN strCmp
    je .agregarNodo

    lea r15, [r12 + nodo_offset_next]; avanzo nodo**
    mov r12, [r15]; avanzo el nodo
    jmp .recorrer
.agregarNodo:
    mov rdi, tam_nodo
    sub rsp, 8
    call malloc
    add rsp, 8

    ;completo info nuevo nodo
    mov [rax + nodo_offset_dato], r13; guardo el dato*
    mov [rax + nodo_offset_next], r12; actualizo next del nuevo Nodo
    mov r8, [r12 + nodo_offset_prev]; guardo el nodo previo a r12
    mov [rax + nodo_offset_prev], r8; actualizo prev del nuevo nod

    ;actualizo nodo anterior y posterior
    mov [r15], rax ;actualizo el puntero a siguiente con el nuevo nodo
    mov [r12 + nodo_offset_prev], rax; actualizo el puntero a anterior del nodo siguiente
    jmp .fin
.agregarUltimo:
    sub rsp, 8
    mov rdi, rbx
    mov rsi, r13
    call listAddLast
    add rsp, 8
.fin:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret


listRemove:
    ;rdi <- lista*
    ;rsi <- data*
    ;rdx <- funcCmp*
    ;rcx <- funcDelete*
    push rbp
	mov rbp, rsp

    push r12
    push r13
    push r14
    push r15
    push rbx

    mov r13, rsi; r13  <- data*
    mov r14, rdx; r14  <- funcCmp*
    mov r15, rcx; r15  <- funcDelete*
    mov rdx, rdi; rdx  <- lista*
    lea r12, [rdi + lista_offset_first]; r12  <- lista* (puntero a puntSig)
    mov rbx, [r12]; rbx <- actual

.recorrer:
    cmp qword rbx, NULL;    me fijo si el actual es NULL
    je .fin

    mov rdi, [rbx + nodo_offset_dato]
    mov rsi, r13
    push rdx
    call r14; llamo a la función para comparar
    pop rdx

    cmp dword eax, NULL; me fijo si funCmp dio 0 y debo borrarlo
    je .deleteCmp

    lea r12, [rbx + nodo_offset_next]
    jmp .seguir
.deleteCmp:
    cmp qword r15, NULL
    je .actualizarNodos
.borrarNodoyDato:
    mov rdi, [rbx + nodo_offset_dato]; libero memoria del dato
    push rdx
    call r15; libero memoria del dato
    pop rdx
.actualizarNodos:
    mov r8, [rbx + nodo_offset_next]; tomo el puntero al nodo siguiente
    mov [r12], r8;actualizo el puntero a siguiente
    
    mov r9, [rbx + nodo_offset_prev]; tomo el puntero al nodo anterior
    ;OJO SI R8 ES NULL PORQUE SIGNIFICA QUE TERMINÓ
    cmp qword r8, NULL
    je .cambiarLast
    mov [r8 + nodo_offset_prev], r9; actualizo el puntero a anterior del nodo siguiente
    jmp .borrar
.cambiarLast:
    mov [rdx + lista_offset_last], r9
.borrar:
    mov rdi, rbx; libero memoria del nodo
    push rdx
    call free; libero memoria del nodo
    pop rdx
.seguir:
    mov rbx, [r12]; avanzo el nodo
    jmp .recorrer
.fin:
;    mov [rdx + lista_offset_last], rbx
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret






listRemoveFirst:
    ;rdi <- lista
    ;rsi <- funcDelete
    cmp qword [rdi + lista_offset_first], NULL  ;me fijo si es vacia
    je .fin

    push rbp
	mov rbp, rsp
    
    mov rcx, [rdi + lista_offset_first]; rcx <- primer nodo
    mov rdx, [rcx + nodo_offset_next]; rdx <- nodoSig
    mov [rdi + lista_offset_first], rdx; apunto el first al nodo siguiente (si rdx era NULL, ya puse el first en null)

    cmp rdx, qword NULL;    si rdx es null entonces había 1 solo nodo y al borrarlo el last debe quedar en null
    je .unicoElem
     
.multiplesElem:
    mov qword [rdx + nodo_offset_prev], NULL;   pongo en null el antecesor
    jmp .borrar
.unicoElem:
    mov qword [rdi + lista_offset_last], NULL; pongo el last en null
.borrar:
    mov rdi, rcx
    cmp qword rsi, 0
    je .borroNodo
    push rdi
    sub rsp, 8
    mov rdi, [rcx + nodo_offset_dato]
    call rsi
    add rsp, 8    
    mov rsi, printString;   rsi <- "%s"
    pop rdi
.borroNodo:
    call free
    pop rbp
.fin:
    ret



listRemoveLast:
    ;rdi <- lista*
    ;rsi <- funcDelete*
    cmp qword [rdi + lista_offset_first], NULL  ;me fijo si es vacia
    je .fin

    push rbp
	mov rbp, rsp
    
    mov rcx, [rdi + lista_offset_last]; rcx <- ultimo nodo a borrar
    mov rdx, [rcx + nodo_offset_prev]; rdx <- nodoPrev
    mov [rdi + lista_offset_last], rdx; apunto el last al nodo anterior (si rdx era NULL, ya puse el last en null)

    cmp rdx, qword NULL;    si rdx es null entonces había 1 solo nodo y al borrarlo el last debe quedar en null
    je .unicoElem
     
.multiplesElem:
    mov qword [rdx + nodo_offset_next], NULL;   pongo en null el sucesor
    jmp .borrar
.unicoElem:
    mov qword [rdi + lista_offset_first], NULL; pongo el first en null
.borrar:
    mov rdi, rcx
    cmp qword rsi, 0
    je .borroNodo
    push rdi
    sub rsp, 8
    mov rdi, [rcx + nodo_offset_dato]
    call rsi
    add rsp, 8
    pop rdi
.borroNodo:
    call free
    pop rbp
.fin:
    ret



listDelete:
    ;rdi <- lista
    ;rsi <- funcDelete
    push rbp
	mov rbp, rsp

    push r12
    push r14

    mov r12, rdi;   r12 <- lista
    mov r14, rsi;   r14 <- funcDelete
.ciclo:
    cmp qword [r12 + lista_offset_first], NULL
    je .borrarLista
    mov rdi, r12
    mov rsi, r14
    call listRemoveFirst
    jmp .ciclo
.borrarLista:
    mov rdi, r12
    call free
.fin:
    pop r14
    pop r12
    pop rbp
    ret



listPrint:;FALTA AGREGAR CORCHETES Y COMAS Y EL CASO DE LA LISTA VACIA
    ;rdi <- lista
    ;rsi <- pFile
    ;rdx <- funcPrint
    push rbp
	mov rbp, rsp

    push r12
    push r13
    push r14
    push r15

    mov r12, rsi; r12 <- pFile*
    mov r13, rdx; r13 <- funcPrint
    mov r14, [rdi + lista_offset_first]; r14 <- primerNodo
    mov r15, rdi

    ;PONGO EL CORCHETE [
    mov rdi, r12;   rdi <- pFile*
    mov rsi, printString
    mov rdx, corcheteIzq
    call fprintf

    cmp qword [r15 + lista_offset_first], NULL;    me fijo si la lista es vacía
    je .fin
    
    cmp qword r13, NULL;    me fijo si funcPrint es 0
    je .imprimirDir
.imprimirDatos:
    mov rdi, [r14 + nodo_offset_dato]; rdi <- dato*
    mov rsi, r12;   rsi <- pFile
    call r13;  salto a función print
    cmp qword [r14 + nodo_offset_next], NULL;   me fijo si llegue al final
    je .fin
    ;pongo la coma
    mov rdi, r12;   rdi <- pFile*
    mov rsi, printString
    mov rdx, comma
    call fprintf
    ;busco el proximo nodo
    mov r14, [r14 + nodo_offset_next]
    jmp .imprimirDatos
.imprimirDir:
    mov rdx, [r14 + nodo_offset_dato]; rdx <- dato*
    mov rsi, dataPointer;   rsi <- "%p"
    mov rdi, r12;   rdi <- pFile*
    call fprintf
    cmp qword [r14 + nodo_offset_next], NULL;   me fijo si llegue al final
    je .fin
    ;pongo la coma
    mov rdi, r12;   rdi <- pFile*
    mov rsi, printString
    mov rdx, comma
    call fprintf
    ;busco el proximo nodo
    mov r14, [r14 + nodo_offset_next]
    jmp .imprimirDir
.fin:
    mov rdi, r12;   rdi <- pFile*
    mov rsi, printString
    mov rdx, corcheteDer
    call fprintf
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret



;/////////////////////////////////////////////////////HASH////////////////////////////////////////////////////////////////////


hashTableNew:
    ;edi <- size (int32)
    ;rsi <- funHash*
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
    push r15

    mov r12d, edi;  r12d <- size (int32)
    mov r13, rsi;   r13 <- funHash*

    mov rdi, tam_hash
    call malloc
    mov r14, rax

    mov [r14 + hTable_offset_funHash], r13
    mov [r14 + hTable_offset_size], r12d
    ; ESTO HAY QUE SETEARLO DESPUES: 
.armarArray:
    mov dword eax, 8;pongo 8 porque necesito 8 bytes para tener un puntero a lista
    mul r12d; multiplico por el tamaño indicado en esi (int32)
    mov edi, edx; guardo la parte alta
    shl rdi, 32; shifteo 32 bits para poner ahora la parte baja
    mov edi, eax; pongo la parte baja del numero

    call malloc; pido la memoria necesaria
    mov r15, rax; r15 <- listArray
    mov [r14 + hTable_offset_array], r15

    xor rcx, rcx; limpio contador
    mov ecx, r12d
.inicializarListas:
    push rcx
    sub rsp, 8
    call listNew
    add rsp, 8
    pop rcx
    mov [r15 + rcx*8 - 8], rax
    loop .inicializarListas
.fin:
    mov rax, r14
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

hashTableAdd:
    ;rdi <- hTable*
    ;rsi <- data*
    push rbp
    mov rbp, rsp

    push r12
    push r13

    mov r12, rdi;   r12 <- hTable*
    mov r13, rsi;   r13 <- data*

    ;consigo el hash correspondiente
    mov rdi, rsi;   rdi <- data*
    mov rcx, [r12 + hTable_offset_funHash]; rcx <- funHash*
    call rcx; rax <- hash

    ;consigo la lista de la posicion del array correspondiente
    xor rdx, rdx
    mov ecx, [r12 + hTable_offset_size]; tamaño array
    div ecx; deja en EDX el resto de la división de EAX(hash) por ECX(size)

    ;tomo el array e indexo según el slot correspondiente haciendo luego la inserción
    mov rcx, [r12 + hTable_offset_array]; rcx <- array
    mov rdi, [rcx + rdx*8]; rdi <- lista*
    mov rsi, r13; rsi <- data*
    call listAddLast
.fin:
    pop r13
    pop r12
    pop rbp
    ret
    
hashTableDeleteSlot:
    ;rdi <- hTable*
    ;esi <- slot
    ;rdx <- funDelete*
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14

    xor r13, r13; limpio r13
    mov r12, rdi;   r12 <- hTable*
    mov r13d, esi;  r13d <- slot (int32)
    mov r14, rdx;   r14 <- funDelete*

    ;consigo la lista de la posicion del array correspondiente
    mov eax, r13d; eax <- slot (int32)
    xor rdx, rdx
    mov ecx, [r12 + hTable_offset_size]; tamaño array
    div ecx; deja en EDX el resto de la división de EAX(slot) por ECX(size)
    mov r13d, edx

    ;tomo el array e indexo según el slot y elimino la lista
    mov rcx, [r12 + hTable_offset_array]; rcx <- array
    mov rdi, [rcx + rdx*8]; rdi <- lista*
    mov rsi, r14; rsi <- funDelete*
    push rcx
    call listDelete; elimino la lista

    ;genero una lista nueva
    call listNew
    pop rcx
    mov [rcx + r13*8], rax
.fin:
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

hashTableDelete:
    ;rdi <- hTable*
    ;rsi <- funDelete*
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
   
    mov r12, rdi; r12 <- hTable*
    mov r13, rsi; r13 <- funDelete*
    mov r14, [rdi + hTable_offset_array]; r14 <- array*
    xor rcx, rcx; limpio contador
    mov ecx, [rdi + hTable_offset_size]; ecx <- size

.eliminarListas:
    mov rdi, [r14 + rcx*8 - 8]; rdi <- lista*
    mov rsi, r13; rsi <- funDelete*
    push rcx
    call listDelete
    pop rcx
    loop .eliminarListas
.eliminarHashTable:
    sub rsp, 8
    mov rdi, r14
    call free
    mov rdi, r12
    call free
    add rsp, 8
.fin:
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
