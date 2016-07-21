dnl Configure-time switch with default
dnl
dnl Each switch defines an --enable-FOO and --disable-FOO option in
dnl the resulting configure script.
dnl
dnl Usage:
dnl smr_SWITCH(name, description, default, pos-def, neg-def)
dnl
dnl where:
dnl
dnl name        name of switch; generates --enable-name & --disable-name
dnl             options
dnl description help string is set to this prefixed by "enable" or
dnl             "disable", whichever is the non-default value
dnl default     either "on" or "off"; specifies default if neither
dnl             --enable-name nor --disable-name is specified
dnl pos-def     a symbol to AC_DEFINE if switch is on (optional)
dnl neg-def     a symbol to AC_DEFINE if switch is off (optional)
dnl
AC_DEFUN(smr_SWITCH, [
    AC_MSG_CHECKING(whether to enable $2)
    AC_ARG_ENABLE(
        $1,
        ifelse($3, on,
            [  --disable-[$1]    disable [$2]],
            [  --enable-[$1]     enable [$2]]),
        [ if test "$enableval" = yes; then
            AC_MSG_RESULT(yes)
            ifelse($4, , , AC_DEFINE($4))
        else
            AC_MSG_RESULT(no)
            ifelse($5, , , AC_DEFINE($5))
        fi ],
        ifelse($3, on,
           [ AC_MSG_RESULT(yes)
             ifelse($4, , , AC_DEFINE($4)) ],
           [ AC_MSG_RESULT(no)
            ifelse($5, , , AC_DEFINE($5))]))])

dnl
dnl Examine size_t and define SIZE_T_IS_UINT, if size_t is an unsigned int
dnl
AC_DEFUN(OJ_SIZE_T_IS_UINT,[
	AC_REQUIRE([AC_TYPE_SIZE_T])
	AC_MSG_CHECKING(whether size_t is unsigned int)
	ac_cv_size_t_is_uint=no
	AC_LANG_SAVE
	AC_LANG_CPLUSPLUS
	AC_TRY_COMPILE([#include <unistd.h>

                       template<class T> class foo { };

                        ], [
			foo<size_t> x;
			foo<unsigned int> y;
			x = y;
		],ac_cv_size_t_is_uint=yes)
	AC_LANG_RESTORE
	AC_MSG_RESULT($ac_cv_size_t_is_uint)
	test "$ac_cv_size_t_is_uint" = "yes" && AC_DEFINE(SIZE_T_IS_UINT)
])
