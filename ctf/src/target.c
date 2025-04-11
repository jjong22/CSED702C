#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sys/types.h>

void init(void) { // DO NOT REMOVE
  setreuid(geteuid(), geteuid());
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin, NULL, _IONBF, 0);
}

void vuln(int random_state)
{
  while(1)
  {
    int a1, a2, a3, a4, a5, a6;
    char buffer[0x100] = { 0, };
    int num_inputed_arr[6];
    int lotto_result;

    printf("Enter 6 numbers to get a prize! (1-45)\n");
    gets(buffer);

    get_arr_from_cstring(num_inputed_arr, buffer);
    lotto_result = check_lotto_number(random_state, num_inputed_arr);

    if (lotto_result == 1) break;
  }

  printf("succes!! Here is your flag.\n");
  system("/bin/sh");
}         
         
void get_arr_from_cstring(int num_inputed_arr[], char buffer[])
{ 
  char *ptr = strtok(buffer, " ");
      
  int i = 0;
  while(ptr)
  { 
    num_inputed_arr[i++] = atoi(ptr);
    ptr = strtok(NULL, " "); 
  } 
}   
    
int check_lotto_number(int random_state, int num_inputed_arr[])
{
  srand(time(NULL) + random_state); // clear rand when start program! you cant predict random XD

  for (int i = 0; i < 6; i++)
  {
    int tmp = (rand() % 45 + 1);
    printf("try %d |  input : %d / system : %d\n", i, num_inputed_arr[i], tmp);

    if (num_inputed_arr[i] != tmp)
    {
      printf("Oh, we cound't get a lotto ;(\n");
      return 0;
    }
  }

  return 1;
}

int main(int argc, char** argv) {
  int byte_count = 64;
  char data[64];
  FILE *fp;
  fp = fopen("/dev/urandom", "r");
  fread(&data, 1, byte_count, fp);
  fclose(fp);

  int random_state = *(int *)data;

  init(); // DO NOT REMOVE

  vuln(random_state);

  return 0;
}