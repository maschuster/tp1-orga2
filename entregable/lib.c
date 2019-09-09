#include "lib.h"

/** STRING **/

char* strSubstring(char* pString, uint32_t inicio, uint32_t fin) {
    char* newStr;
    uint32_t len = strLen(pString);//Esto vale si es la de asm, no? (Ver enunciado que dice que no puede usarse la de C)
    if(inicio > fin){
        newStr = strClone(pString);
        free(pString);
        return newStr;
    }
    if(inicio > len){
        newStr = strClone("");
        free(pString);
        return newStr;
    }
    if(fin >= len){
        fin = len-1;
    }
    pString[fin+1] = (char) 0;
    newStr = strClone(pString + inicio);
    free(pString);
    return newStr;
}

/** Lista **/

void listPrintReverse(list_t* pList, FILE *pFile, funcPrint_t* fp) {
    listElem_t* nodoActual = pList->last;
    char* corcheteIzq = strClone("[");
    char* corcheteDer = strClone("]");
    char* comma = strClone(",");
    fprintf(pFile,"%s", corcheteIzq);
    while(nodoActual != NULL){
        fp(nodoActual->data, pFile);
        if(nodoActual->prev != NULL){
            fprintf(pFile,"%s", comma);
        }
        nodoActual = nodoActual->prev;
    }
    fprintf(pFile,"%s", corcheteDer);
    strDelete(corcheteDer);
    strDelete(corcheteIzq);
    strDelete(comma);
}

/** HashTable **/

uint32_t strHash(char* pString) {
  if(strLen(pString) != 0)
      return (uint32_t)pString[0] - 'a';
  else
      return 0;
}

void hashTableRemoveAll(hashTable_t* pTable, void* data, funcCmp_t* fc, funcDelete_t* fd) {
    uint64_t slot = strHash(data) % pTable->size;
    struct s_list *lista = pTable->listArray[slot];
    listRemove(lista, data, fc, fd);
}

void hashTablePrint(hashTable_t* pTable, FILE *pFile, funcPrint_t* fp) {
    uint32_t pSize = pTable->size;
    uint32_t i = 0;
    while (i < pSize){
        fprintf(pFile,"%i", i);
        fprintf(pFile,"%s", " = ");
        struct s_list *lista = pTable->listArray[i];
        listPrint(lista, pFile, fp);
        fprintf(pFile,"\n");
        i=i+1;
    }
}
