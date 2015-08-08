/* # $Id$

   Convert external TAI64N timestamps to fractional seconds since epoch.

   Written by Russ Allbery <rra@stanford.edu>
   This work is in the public domain.

Usage:

tai64nfrac < input > output

Expects the input stream to be a sequence of lines beginning with @, a
timestamp in external TAI64N format, and a space.  Replaces the @ and the
timestamp with fractional seconds since epoch (1970-01-01 00:00:00 UTC).
The input time format is the format written by tai64n and multilog.  The
output time format is expected by qmailanalog. */

#include <stdio.h>

/* Read a TAI64N external format timestamp from stdin and write fractional
   seconds since epoch (TAI, not UTC) to stdout.  Return the character after
   the timestamp. */
int decode(void)
{
    int c;
    unsigned long u;
    unsigned long seconds = 0;
    unsigned long nanoseconds = 0;

    while ((c = getchar()) != EOF) 
    {
	u = c - '0';
	if (u >= 10) 
	{
	    u = c - 'a';
	    if (u >= 6) break;
	    u += 10;
	}
	seconds <<= 4;
	seconds += nanoseconds >> 28;
	nanoseconds &= 0xfffffff;
	nanoseconds <<= 4;
	nanoseconds += u;
    }
    seconds -= 4611686018427387914ULL;
    printf("%lu.%lu ", seconds, nanoseconds);
    return c;
}


int main(void)
{
    int c;
    unsigned long seconds;
    unsigned long nanoseconds;

    while ((c = getchar()) != EOF)
    {
	if (c == '@') c = decode();
	while (c != EOF) 
	{
	    putchar(c);
	    if (c == '\n') break;
	    c = getchar();
	}
    }
}
