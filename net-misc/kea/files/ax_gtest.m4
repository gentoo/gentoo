AC_DEFUN([AX_ISC_GTEST], [

AC_ARG_WITH([lcov],
            [AS_HELP_STRING([--with-lcov[[=PROGRAM]]],
                            [enable gtest and coverage target using the specified lcov])],
                            [lcov="$withval"],
                            [lcov="no"])

USE_LCOV="no"
if test "$lcov" != "no"; then
        # force gtest if not set
        if test "$enable_gtest" = "no"; then
#               AC_MSG_ERROR("lcov needs gtest for test coverage report")
                AC_MSG_NOTICE([gtest support is now enabled, because used by coverage tests])
                enable_gtest="yes"
        fi
        if test "$lcov" != "yes"; then
                LCOV=$lcov
        else
                AC_PATH_PROG([LCOV], [lcov])
        fi
        if test -x "${LCOV}"; then
                USE_LCOV="yes"
        else
                AC_MSG_ERROR([Cannot find lcov.])
        fi
        # is genhtml always in the same directory?
        GENHTML=`echo "$LCOV" | ${SED} s/lcov$/genhtml/`
        if test ! -x $GENHTML; then
                AC_MSG_ERROR([genhtml not found, needed for lcov])
        fi
        # GCC specific?
        CXXFLAGS="$CXXFLAGS -fprofile-arcs -ftest-coverage"
        LIBS=" $LIBS -lgcov"
        AC_SUBST(CPPFLAGS)
        AC_SUBST(LIBS)
        AC_SUBST(LCOV)
        AC_SUBST(GENHTML)
fi
AC_SUBST(USE_LCOV)

#
# Check availability of gtest, which will be used for unit tests.
#
DISTCHECK_GTEST_CONFIGURE_FLAG=

AS_IF([test "x$enable_gtest" = "xyes"], [
    DISTCHECK_GTEST_CONFIGURE_FLAG="--with-gtest"
    PKG_CHECK_MODULES([GTEST], [gtest], [], [AC_MSG_ERROR([gtest requested but not found])])
    GTEST_INCLUDES=`${PKG_CONFIG} --keep-system-cflags --cflags-only-I gtest`
    GTEST_LDFLAGS=`${PKG_CONFIG} --keep-system-libs --libs-only-L gtest`
    GTEST_VERSION=`${PKG_CONFIG} --modversion gtest`
])

AM_CONDITIONAL(HAVE_GTEST, test $enable_gtest != "no")
AM_CONDITIONAL(HAVE_GTEST_SOURCE, test "X$have_gtest_source" = "Xyes")
AC_SUBST(DISTCHECK_GTEST_CONFIGURE_FLAG)
AC_SUBST(GTEST_INCLUDES)
AC_SUBST([GTEST_LDADD], [$GTEST_LIBS])
AC_SUBST(GTEST_SOURCE)

])dnl AX_ISC_GTEST
