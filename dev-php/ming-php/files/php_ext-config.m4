dnl
dnl $Id: php_ext-config.m4,v 1.1 2015/01/22 17:25:49 grknight Exp $
dnl

PHP_LIBDIR=lib

PHP_ARG_WITH(ming, for MING support,
[  --with-ming[=DIR]       Include MING support])

if test "$PHP_MING" != "no"; then
  AC_CHECK_LIB(m, sin)

  for i in $PHP_MING ../../src /usr/local /usr; do
    if test -f $i/$PHP_LIBDIR/libming.$SHLIB_SUFFIX_NAME || test -f $i/$PHP_LIBDIR/libming.a; then
      MING_DIR=$i
      break
    fi
  done

  if test -z "$MING_DIR"; then
    AC_MSG_ERROR(Please reinstall ming distribution. libming.(a|so) not found.)
  fi

  for i in ../../src $MING_DIR/include $MING_DIR/include/ming $MING_DIR/ming/include; do
    if test -f $i/ming.h; then
      MING_INC_DIR=$i
    fi
  done

  if test -z "$MING_INC_DIR"; then
    AC_MSG_ERROR(Please reinstall ming distribution. ming.h not found.)
  fi

  PHP_CHECK_LIBRARY(ming, Ming_useSWFVersion, [
    AC_DEFINE(HAVE_MING,1,[ ])
  ],[
    AC_MSG_ERROR([Ming library 0.2a or greater required.])
  ],[
    -L$MING_DIR/$PHP_LIBDIR
  ])
  
  PHP_ADD_INCLUDE($MING_INC_DIR)
  PHP_ADD_LIBRARY_WITH_PATH(ming, $MING_DIR/$PHP_LIBDIR, MING_SHARED_LIBADD)

  old_CPPFLAGS=$CPPFLAGS
  CPPFLAGS=-I$MING_INC_DIR
  AC_MSG_CHECKING([for destroySWFBlock])
  AC_TRY_RUN([
#include "ming.h"
int destroySWFBlock(int a, int b) {
	return a+b;
}
int main() {
	return destroySWFBlock(-1,1); /* returns 0 only if function is not yet defined */
}
  ],[
    AC_MSG_RESULT([missing])
  ],[
    AC_DEFINE(HAVE_DESTROY_SWF_BLOCK,1,[ ])
    AC_MSG_RESULT([ok])
  ],[
    AC_MSG_RESULT([unknown])
  ]) 

dnl Check Ming version (FIXME: if/when ming has some better way to detect the version..)
  AC_EGREP_CPP(yes, [
#include <ming.h>
#ifdef SWF_SOUND_COMPRESSION
yes
#endif
  ], [
    AC_DEFINE(HAVE_NEW_MING,  1, [ ]) 
    dnl FIXME: This is now unconditional..better check coming later.
  ])

  dnl Check if SWFVideoStream_setFrameMode() is available
  AC_TRY_COMPILE([
#include <ming.h>
  ], [
int main(void) { SWFVideoStream_setFrameMode(0, 0); return 0; }
  ], [
    AC_DEFINE(HAVE_SWFVIDEOSTREAM_SETFRAMEMODE, 1, [Have SWFVideoStream_setFrameMode(SWFVideoStream, int)])
  ], [])

  dnl Check if SWFVideoStream_nextFrame() is available
  AC_TRY_COMPILE([
#include <ming.h>
  ], [
int main(void) { SWFVideoStream_nextFrame(0); return 0; }
  ], [
    AC_DEFINE(HAVE_SWFVIDEOSTREAM_NEXTFRAME, 1, [Have SWFVideoStream_nextFrame(SWFVideoStream)])
  ], [])

  dnl Check if SWFVideoStream_seek() is available
  AC_TRY_COMPILE([
#include <ming.h>
  ], [
int main(void) { SWFVideoStream_seek(0, 0, 0); return 0; }
  ], [
    AC_DEFINE(HAVE_SWFVIDEOSTREAM_SEEK, 1, [Have SWFVideoStream_seek(SWFVideoStream, int frame, int whence)])
  ], [])


  dnl Check if SWFMovie_output() accepts the 4th parameter
  AC_TRY_COMPILE([
#include <ming.h>
  ], [
int main(void) { SWFMovie_output(NULL, NULL, NULL, 0); return 0; }
  ], [
    AC_DEFINE(HAVE_MING_MOVIE_LEVEL, 1, [ ])
  ], [])
  CPPFLAGS=$old_CPPFLAGS

  PHP_NEW_EXTENSION(ming, ming.c, $ext_shared)
  PHP_SUBST(MING_SHARED_LIBADD)
fi
