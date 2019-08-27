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
    // concat
    fprintf(pfile,"==> Concat\n");
    a = strClone("perro_");
    b = strClone("loco");
    fprintf(pfile,"%i\n",strLen(a));
    fprintf(pfile,"%i\n",strLen(b));
    c = strConcat(a,b);
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    c = strConcat(c,strClone(""));
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    c = strConcat(strClone(""),c);
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    c = strConcat(c,c);
    strPrint(c,pfile);
    fprintf(pfile,"\n");
    /*
    // Substring
    fprintf(pfile,"==> Substring\n");
    fprintf(pfile,"%i\n",strLen(c));
    int h = strLen(c);
    for(int i=0; i<h+1; i++) {
        for(int j=0; j<h+1; j++) {    
            a = strClone(c);
            a = strSubstring(a,i,j);
            strPrint(a,pfile);
            fprintf(pfile,"\n");
            strDelete(a);
        }
        fprintf(pfile,"\n");
    }
    strDelete(c);
    */
    // cmp
    fprintf(pfile,"==> Cmp\n");
    char* texts[5] = {"sar","23","taaa","tbb","tix"};
    for(int i=0; i<5; i++) {
        for(int j=0; j<5; j++) {
            fprintf(pfile,"cmp(%s,%s) -> %i\n",texts[i],texts[j],strCmp(texts[i],texts[j]));
        }
    }
}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_hashTable(pfile);
    test_strings(pfile);
    fclose(pfile);
    return 0;
}