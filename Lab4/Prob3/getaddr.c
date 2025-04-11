#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
	char *env;
    
    env=getenv("SHELLCODE");
    printf("value of SHELLCODE: %s",env);		
 	
    printf("address of SHELLCODE: %p",env);
    return 0;
}