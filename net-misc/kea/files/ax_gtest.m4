AC_DEFUN([AX_ISC_GTEST], [

USE_LCOV="no"
AC_SUBST(USE_LCOV)

DISTCHECK_GTEST_CONFIGURE_FLAG="--with-gtest"
PKG_CHECK_MODULES([GTEST], [gtest], [], [AC_MSG_ERROR([gtest requested but not found])])
GTEST_INCLUDES=`${PKG_CONFIG} --keep-system-cflags --cflags-only-I gtest`
GTEST_LDFLAGS=`${PKG_CONFIG} --keep-system-libs --libs-only-L gtest`
GTEST_VERSION=`${PKG_CONFIG} --modversion gtest`

AM_CONDITIONAL(HAVE_GTEST, test $enable_gtest != "no")
AM_CONDITIONAL(HAVE_GTEST_SOURCE, test "X$have_gtest_source" = "Xyes")
AC_SUBST(DISTCHECK_GTEST_CONFIGURE_FLAG)
AC_SUBST(GTEST_INCLUDES)
AC_SUBST([GTEST_LDADD], [$GTEST_LIBS])
AC_SUBST(GTEST_SOURCE)

])dnl AX_ISC_GTEST
