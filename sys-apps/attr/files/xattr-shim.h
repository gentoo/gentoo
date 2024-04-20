/* Small shim until we update all packages. */
#ifndef __XATTR_H__
#define __XATTR_H__
#include <sys/xattr.h>
#warning "Please change your <attr/xattr.h> includes to <sys/xattr.h>"
# ifndef ENOATTR
#  define ENOATTR ENODATA
# endif /* ENOATTR */
#endif
