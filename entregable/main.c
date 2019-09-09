#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

char* strings[33] = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","{","|","}","~",";","Z", "["};

/** hashTable **/
void test_hashTable(FILE *pfile) {
    hashTable_t *n;
    n = hashTableNew(33, (funcHash_t*)&strHash);
    fprintf(pfile,"==> hashTableDeleteSimpleTests\n");
    for(int s=0;s<33;s++) {
        hashTableAdd(n, strClone(strings[s]));
    }
    hashTablePrint(n,pfile,(funcPrint_t*)&strPrint);
    hashTableDelete(n,(funcDelete_t*)&strDelete);
}


int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_hashTable(pfile);
    fclose(pfile);
    return 0;
}