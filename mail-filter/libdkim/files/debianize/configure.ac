#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(libdkim, 1.0.21)
LT_INIT
AC_CONFIG_SRCDIR([dkim.cpp])
##AC_CONFIG_HEADER([config.h])

# Checks for programs.
AC_PROG_CXX
PKG_PROG_PKG_CONFIG

# Checks for libraries.
#AC_CHECK_LIB([crypto], [PEM_read_PrivateKey])
PKG_CHECK_MODULES([libcrypto], [libcrypto])
AC_SEARCH_LIBS([res_query], [resolv c],,
               [AC_SEARCH_LIBS(__res_query,resolv bind)])

# Checks for header files.
AC_HEADER_RESOLV
AC_HEADER_STDC
AC_CHECK_HEADERS([netdb.h netinet/in.h inttypes.h stdlib.h string.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_CONST
AC_C_INLINE
AC_HEADER_TIME
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T

# Checks for library functions.
AC_FUNC_MEMCMP
AC_FUNC_SELECT_ARGTYPES
AC_CHECK_FUNCS([select socket strchr])

AC_CONFIG_FILES([Makefile libdkim.pc])
AC_OUTPUT
