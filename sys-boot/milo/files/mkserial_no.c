#include <stdio.h>

/* some example serial numbers for the MILO bootloader */
/* gcc -o mkserial_no mkserial_no.c */
/* taviso@gentoo.org 2003 */

/* NOTE: remember you need a 0x00 (NULL terminator) at the end */

int main()
{
	long long serial_no[2];
	
	/* 1) Linux_is_Great!             */
	/*               s i _ x u n i L  */	
	serial_no[0] = 0x73695f78756e694c;
	/*                 ! t a e r G _  */
	serial_no[1] = 0x002174616572475f; 

	/* 2) Gentoo Linux.               */
	/*               L   o o t n e G  */
	serial_no[0] = 0x4c206f6f746e6547;
	/*                     . x u n i  */
	serial_no[1] = 0x0000002e78756e69;
	
	/* 3) Gentoo/Alpha.               */
	/*                A / o o t n e G */	
	 serial_no[0] = 0x412f6f6f746e6547;
	/*                       .a h p l */
	 serial_no[1] = 0x0000002e6168706c;

	/* 4) Gentoo MILO.                */
	/*               M   o o t n e G  */
	serial_no[0] = 0x4d206f6f746e6547;
	/*                        . O L I */
	serial_no[1] = 0x000000002e4f4c49;

	/* 5) |d|i|g|i|t|a|l|             */
	/*               i | g | i | d |  */
	serial_no[0] = 0x697c677c697c647c;
	/*                 | l | a | t |  */
	serial_no[1] = 0x007c6c7c617c747c;
	
	printf ("serial number:\t%s\n", (char*) serial_no);
	return (0);
}
