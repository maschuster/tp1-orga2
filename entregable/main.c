#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

void test_hashTable(FILE *pfile){
    
}

bool testStrLen(){
    int leng0 = strLen("hola");
    int leng1 = strLen("");
    int leng2 = strLen("hola oaskdnaow oasdaw");
    printf("Resultado1 %d, Resultado2 %d, Resultado3 %d", leng0, leng1, leng2);
    return true;
}

void test_strings(FILE *pfile) {
    char *a, *b, *c;
    // clone
    fprintf(pfile,"==> Clone\n");
    a = strClone("casa");
    b = strClone("");
    strPrint(a,pfile);
    fprintf(pfile,"\n");
    strPrint(b,pfile);
    fprintf(pfile,"\n");
    strDelete(a);
    strDelete(b);
}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_hashTable(pfile);
    test_strings(pfile);
    fclose(pfile);
    return 0;
}