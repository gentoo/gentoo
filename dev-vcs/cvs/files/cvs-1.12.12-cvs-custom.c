/*
Author: Robin H. Johnson <robbat2@gentoo.org>
Date: 2006-08-09

This patch allows a CVS server to deny usage of specific commands, based on
input in the environment.

Just set the CVS_BLOCK_REQUESTS env var with all of the commands you want,
seperated by spaces. Eg:
CVS_BLOCK_REQUESTS="Gzip-stream gzip-file-contents"
would block ALL usage of compression.

Please see the array 'struct request requests[]' in src/server.c for a full
list of commands.

Please note that if you block any commands marked as RQ_ESSENTIAL, CVS clients
may fail! (This includes 'ci'!).

See the companion cvs-custom.c for a wrapper that can enforce the environment variable for pserver setups.

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <malloc.h>


#define REAL_CVS "/bin/cvs"
#define CVS_TMPDIR "/tmp"
#define CMDS_BLOCKED " Gzip-stream gzip-file-contents Kerberos-encrypt Gssapi-encrypt Gssapi-authenticate add remove admin import init history watch-on watch-off watch-add watch-remove watchers editors edit version tag rtag "

int main(int argc, char* argv[]) {
		char** newargv;
		int newargc, offset;
		int i;
		// 0 for argv[0] we must copy
		offset = 0+0;
		// +1 for trailing NULL
		newargc = argc+offset+1;
		newargv = (char**) malloc(newargc*sizeof(char*));
		newargv[0] = "cvs";
		//newargv[1] = "-T";
		//newargv[2] = CVS_TMPDIR;
		//newargv[3] = "-R";
		for(i=1;i<argc;i++) {
				newargv[i+offset] = argv[i];
		}
		newargv[newargc-1] = NULL;
		setenv("CVS_BLOCK_REQUESTS",CMDS_BLOCKED ,1);
		//for(i =0;i<newargc;i++) {
		//		printf("[%d]='%s'\n",i,newargv[i] != NULL ? newargv[i] : "NULL");
		//}
		execv(REAL_CVS,newargv);
		free(newargv);
		return 0;
}
