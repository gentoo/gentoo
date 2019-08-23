#include <stdio.h>

#ifndef REAL_PROCMAIL
#define REAL_PROCMAIL "/usr/bin/procmail"
#endif

int main(int argc, char **argv)
{
setuid(geteuid());
setgid(getegid());

execv(REAL_PROCMAIL, argv);
}
