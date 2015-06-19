#include "substdio.h"
#include "seek.h"
#include "get_header.h"
#include "stralloc.h"
#include "errtxt.h"
#include "strerr.h"

#define FATAL "get_header: fatal: "

static stralloc line = {0};

static void die_nomem()
{
      strerr_die2x(111,FATAL,ERR_NOMEM);
}

/**
 * This function assumes that input is at the begining of the file;
 * and it returns input to that state when the function has completed.
 * The return is 0 if the header was not found, and 1 otherwise.  If
 * found, the header will be stored in the value stralloc struct.
 */
int get_header(input, name, value)
substdio *input;
char *name;
stralloc *value;
{
  int match = 0;
  int found_start = 0;
  unsigned int len;
  char *cp;

  for (;;) {
    if (getln(input, &line, &match, '\n') == -1)
      strerr_die2sys(111, FATAL,ERR_READ_INPUT);
    if (!match) break;
    if (line.len == 1) break;
    cp = line.s ; len = line.len;
    if (found_start) {
      if ((*cp == ' ' || *cp == '\t')) {
        if (!stralloc_catb(value, cp, len - 1)) die_nomem();
      } else {
        break;
      }
    } else {
      if (case_startb(cp,len,"from:")) {
        if (!stralloc_copyb(value, cp, len - 1)) die_nomem();
        found_start = 1;
      }
    }
  }

  if (seek_begin(input->fd) == -1)
    strerr_die2sys(111,FATAL,ERR_SEEK_INPUT);

  return found_start;
}

/**
 * This function makes the same assumptions about input as get_header :
 * it should be at the begining of the file, and once done, seek will
 * be used to return it there.  The return value is an e-mail address if
 * one can be found, or null otherwise.  No attempt is made to validate
 * the email address, and the work done for parsing it is relatively 
 * simplistic; it will handle the following forms as shown:
 *
 * username@domain                             => username@domain
 * "Name <username@domain>"                    => username@domain
 * username1@domain, username2@domain          => username1@domain
 * username1@domain, "Name <username2@domain>" => username2@domain
 *
 * If junk is present in the From: header, this will return that.  This
 * function may not be appropriate if a valid e-mail address is required.
 */
char *get_from(input)
substdio *input;
{
  stralloc from_header = {0};
  int from_complete = 0, i;
  char *from_addr = (char *) 0;

  if (!get_header(input, "from:", &from_header))
    return (char *) 0;

  /* issub uses a char *, and stralloc structures aren't null
   * terminated -- they're ... 'Z' terminated ...
   * but the stuff in from_header is a copy anyway ... we'll modify it so
   * we don't have to do strcpy or somesuch.
   */
  for (i = strlen("from:") ; i < from_header.len ; ++i) {
    if (*(from_header.s + i) == '<') {
      from_addr = from_header.s + (i + 1);
    } else if (from_addr && *(from_header.s + i) == '>') {
      from_complete = 1;
      *(from_header.s+i) = '\0'; /* null terminate so from_addr is valid */
      break;
    }
  }
  if (!from_complete) { /* <...> not found ... assume a simpler format */
    for(i = strlen("from:") ; i < from_header.len ; ++i) {
      if (!from_addr && *(from_header.s + i) != ' ') {
        from_addr = from_header.s + i;
      } else if (from_addr && isspace(*(from_header.s + i)) ||
          *(from_header.s + i) == ',') {
        break;
      }
    }
    *(from_header.s + i) = '\0'; /* this is safe even if i == from_header.len */
                                 /* because strallocs have an extra char      */
  }
  return from_addr;
}

