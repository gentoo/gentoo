/*
 * Wrapper to help enable colorized man page output.
 * Only works with PAGER=less
 *
 * https://bugs.gentoo.org/184604
 * https://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables
 *
 * Copyright 2003-2015 Gentoo Foundation
 * Distributed under the terms of the GNU General Public License v2
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define COLOR(c, b) "\e[" #c ";" #b "m"

#define _SE(termcap, col) setenv("LESS_TERMCAP_" #termcap, col, 0)
#define SE(termcap, c, b) _SE(termcap, COLOR(c, b))

static int usage(void)
{
	puts(
		"manpager: display man pages with color!\n"
		"\n"
		"Usage:\n"
		"\texport MANPAGER=manpager\n"
		"\tman man\n"
		"\n"
		"To control the colorization, set these env vars:\n"
		"\tLESS_TERMCAP_mb - start blinking\n"
		"\tLESS_TERMCAP_md - start bolding\n"
		"\tLESS_TERMCAP_me - stop bolding\n"
		"\tLESS_TERMCAP_us - start underlining\n"
		"\tLESS_TERMCAP_ue - stop underlining\n"
		"\tLESS_TERMCAP_so - start standout (reverse video)\n"
		"\tLESS_TERMCAP_se - stop standout (reverse video)\n"
		"\n"
		"You can do so by doing:\n"
		"\texport LESS_TERMCAP_md=\"$(printf '\\e[1;36m')\"\n"
		"\n"
		"Run 'less --help' or 'man less' for more info"
	);
	return 0;
}

int main(int argc, char *argv[])
{
	if (argc == 2 && (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help")))
		return usage();

	/* Blinking. */
	SE(mb, 5, 31);	/* Start. */

	/* Bolding. */
	SE(md, 1, 34);	/* Start. */
	SE(me, 0, 0);	/* Stop. */

	/* Underlining. */
	SE(us, 4, 36);	/* Start. */
	SE(ue, 0, 0);	/* Stop. */

#if 0
	/* Standout (reverse video). */
	SE(so, 1, 32);	/* Start. */
	SE(se, 0, 0);	/* Stop. */
#endif

	argv[0] = getenv("PAGER") ? : "less";
	execvp(argv[0], argv);
	perror("could not launch PAGER");
	return 1;
}
