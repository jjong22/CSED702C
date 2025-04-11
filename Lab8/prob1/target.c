#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "init.h"

char global_buf[0x1000];

void load_flag() {
  int fd = open("/proc/flag", O_RDONLY);
  read(fd, global_buf, sizeof(global_buf));
}

int main(int argc, char** argv) {
  init();

  load_flag();

  char buf[256];
  printf("Enter your input...\n");
  ssize_t size = read(0, buf, sizeof(buf) - 1);
  buf[size] = '\0';

  if (!strchr(buf, 'n')) {
    printf(buf); // FSB!
  } else {
    printf("You cannot use 'n'\n");
  }

  return 0;
}
