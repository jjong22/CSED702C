#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "init.h"

int change_this = 0xdeadbeef;

int main(int argc, char** argv) {
  init();

  char *cmd = "/bin/cat /proc/flag";
  char buf[256];

  printf("Change the value of change_this!\n");

  printf("-------- BEFORE --------\n");
  printf("(gdb) x/wx &change_this\n");
  printf("%p: 0x%x\n", &change_this, change_this);
  printf("------------------------\n\n");

  printf("Enter your input...\n");
  ssize_t size = read(0, buf, sizeof(buf) - 1);
  buf[size] = '\0';

  printf("Your input: ");
  printf(buf);

  printf("\n");
  printf("-------- AFTER  --------\n");
  printf("(gdb) x/wx &change_this\n");
  printf("%p: 0x%x\n", &change_this, change_this);
  printf("------------------------\n\n");

  if (change_this == 0xc0ffee) {
    system(cmd);
  } else {
    printf("Wrong!!!\n");
  }
}