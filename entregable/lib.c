#include "lib.h"

/** STRING **/

char* strSubstring(char* pString, uint32_t inicio, uint32_t fin) {
    char* newStr;
    int len = strLen(pString);//Esto vale si es la de asm, no? (Ver enunciado que dice que no puede usarse la de C)
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
    if(fin > len){
        fin = len;
    }
    if(fin == len){
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
    fprintf(pFile,"%s", strClone("["));
    while(nodoActual != NULL){
        fp(nodoActual->data, pFile);
        fprintf(pFile,"%s", strClone(","));
        nodoActual = nodoActual->prev;
    }
    fprintf(pFile,"%s", strClone("]"));
}

/** HashTable **/

uint32_t strHash(char* pString) {
  if(strLen(pString) != 0)
      return (uint32_t)pString[0] - 'a';
  else
      return 0;
}

void hashTableRemoveAll(hashTable_t* pTable, void* data, funcCmp_t* fc, funcDelete_t* fd) {

}

void hashTablePrint(hashTable_t* pTable, FILE *pFile, funcPrint_t* fp) {

}
