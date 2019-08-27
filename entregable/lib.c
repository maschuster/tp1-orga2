#include "lib.h"

/** STRING **/

char* strSubstring(char* pString, uint32_t inicio, uint32_t fin) {
    char* newStr;
    int len = strLen(pString);//Esto vale si es la de asm, no? (Ver enunciado que dice que no puede usarse la de C)
    if (inicio > fin){
        newStr = strClone(pString);
        free(pString);
        return newStr;
    }
    if(inicio > len){
        free(pString);
        newStr = malloc(1);
        *newStr = 0;
        free(pString);
        return newStr;
    }else if (fin > len){
        newStr = malloc(len-inicio + 2); // +1 o +2?
        while(inicio <= len + 1){   //EL +1 es por el 0 que termina el string
            newStr[inicio] = pString[inicio];
            inicio++;
        }
    }else{
        newStr = malloc(fin-inicio + 2);// +1 o +2?
        while(inicio <= fin + 1){   //EL +1 es por el 0 que termina el string
            newStr[inicio] = pString[inicio];
            inicio++;
        }
    }

    return newStr;
}

/** Lista **/

void listPrintReverse(list_t* pList, FILE *pFile, funcPrint_t* fp) {

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
