/* Simple work-around for running the 64-bit Adobe Flash plug-in version 10
   on Athlon64 processors without support for the lahf instruction.

Compile with:
cc -fPIC -shared -nostdlib -lc -oflashplugin-lahf-fix.so flashplugin-lahf-fix.c
Then place the .so file in the plug-in directory (e.g. $HOME/.mozilla/plugins)
or use LD_PRELOAD to force Firefox to load the library.

   - Maks Verver <maksverver@geocities.com> July 2009 */

#define _GNU_SOURCE
#include <stdlib.h>
#include <signal.h>
#include <ucontext.h>

static void sig_handler(int signal, siginfo_t *info, void *context) {
	if (signal != SIGILL) return;
	if (*(char*)info->si_addr != (char)0x9f) abort();
	greg_t *regs = ((ucontext_t*)context)->uc_mcontext.gregs;
	((char*)&regs[REG_RAX])[1] = ((char*)&regs[REG_EFL])[0];
	regs[REG_RIP]++;
}

static struct sigaction old_sa, new_sa = {
	.sa_flags     = SA_SIGINFO,
	.sa_sigaction = &sig_handler };

int _init() { sigaction(SIGILL, &new_sa, &old_sa); return 0; }
int _fini() { sigaction(SIGILL, &old_sa, &new_sa); return 0; }
