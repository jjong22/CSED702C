#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "init.h"
#include "flag.h"

void (**func)() = NULL;

void safe_func() {
  printf("** You have invoked a safe function\n");
}

void evil() {
  printf("** You have invoked an evil function\n");
  print_flag("uaf");
}

void register_func() {
  printf("[+] Registering a safe function!\n");
  func = malloc(sizeof(safe_func));
  *func = safe_func;
}

void call_func() {
  printf("[+] Calling the registered function\n");
  if (func != NULL)
    (*func)();
}

void remove_func() {
  printf("[+] Removing the registered function\n");
  free(func);
}

void echo() {
  char buf[0x100];
  char *echo_buf;

  printf("Enter message to echo\n");
  fgets(buf, sizeof(buf), stdin);
  echo_buf = malloc(strlen(buf));
  strcpy(echo_buf, buf);

  printf("%s\n", echo_buf);
}

void print_menu() {
  printf("\n\
1. Register a safe function\n\
2. Remove the registered function\n\
3. Call the registered function\n\
4. Echo\n\
5. Exit\n\
> ");
}

int main() {
  setreuid(geteuid(), geteuid());
  char buf[10];

  while(true) {
    print_menu();

    fgets(buf, sizeof(buf), stdin);
    switch(atoi(buf)) {
      case 1:
        register_func();
        break;
      case 2:
        remove_func();
        break;
      case 3:
        call_func();
        break;
      case 4:
        echo();
        break;
      case 5:
        exit(0);
    }
  }
}