# Configure paths for GLIB
# Owen Taylor     97-11-3

dnl AM_PATH_GLIB([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND [, MODULES]]]])
dnl Test for GLIB, and define GLIB_CFLAGS and GLIB_LIBS, if "gmodule" or 
dnl gthread is specified in MODULES, pass to glib-config
dnl
AC_DEFUN(AM_PATH_GLIB,
[dnl 
dnl Get the cflags and libraries from the glib-config script
dnl
AC_ARG_WITH(glib-prefix,[  --with-glib-prefix=PFX   Prefix where GLIB is installed (optional)],
            glib_config_prefix="$withval", glib_config_prefix="")
AC_ARG_WITH(glib-exec-prefix,[  --with-glib-exec-prefix=PFX Exec prefix where GLIB is installed (optional)],
            glib_config_exec_prefix="$withval", glib_config_exec_prefix="")
AC_ARG_ENABLE(glibtest, [  --disable-glibtest       Do not try to compile and run a test GLIB program],
		    , enable_glibtest=yes)

  if test x$glib_config_exec_prefix != x ; then
     glib_config_args="$glib_config_args --exec-prefix=$glib_config_exec_prefix"
     if test x${GLIB_CONFIG+set} != xset ; then
        GLIB_CONFIG=$glib_config_exec_prefix/bin/glib-config
     fi
  fi
  if test x$glib_config_prefix != x ; then
     glib_config_args="$glib_config_args --prefix=$glib_config_prefix"
     if test x${GLIB_CONFIG+set} != xset ; then
        GLIB_CONFIG=$glib_config_prefix/bin/glib-config
     fi
  fi

  for module in . $4
  do
      case "$module" in
         gmodule) 
             glib_config_args="$glib_config_args gmodule"
         ;;
         gthread) 
             glib_config_args="$glib_config_args gthread"
         ;;
      esac
  done

  AC_PATH_PROG(GLIB_CONFIG, glib-config, no)
  min_glib_version=ifelse([$1], ,0.99.7,$1)
  AC_MSG_CHECKING(for GLIB - version >= $min_glib_version)
  no_glib=""
  if test "$GLIB_CONFIG" = "no" ; then
    no_glib=yes
  else
    GLIB_CFLAGS=`$GLIB_CONFIG $glib_config_args --cflags`
    GLIB_LIBS=`$GLIB_CONFIG $glib_config_args --libs`
    glib_config_major_version=`$GLIB_CONFIG $glib_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
    glib_config_minor_version=`$GLIB_CONFIG $glib_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
    glib_config_micro_version=`$GLIB_CONFIG $glib_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`
    if test "x$enable_glibtest" = "xyes" ; then
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $GLIB_CFLAGS"
      LIBS="$GLIB_LIBS $LIBS"
dnl
dnl Now check if the installed GLIB is sufficiently new. (Also sanity
dnl checks the results of glib-config to some extent
dnl
      rm -f conf.glibtest
      AC_TRY_RUN([
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

int 
main ()
{
  int major, minor, micro;
  char *tmp_version;

  system ("touch conf.glibtest");

  /* HP/UX 9 (%@#!) writes to sscanf strings */
  tmp_version = g_strdup("$min_glib_version");
  if (sscanf(tmp_version, "%d.%d.%d", &major, &minor, &micro) != 3) {
     printf("%s, bad version string\n", "$min_glib_version");
     exit(1);
   }

  if ((glib_major_version != $glib_config_major_version) ||
      (glib_minor_version != $glib_config_minor_version) ||
      (glib_micro_version != $glib_config_micro_version))
    {
      printf("\n*** 'glib-config --version' returned %d.%d.%d, but GLIB (%d.%d.%d)\n", 
             $glib_config_major_version, $glib_config_minor_version, $glib_config_micro_version,
             glib_major_version, glib_minor_version, glib_micro_version);
      printf ("*** was found! If glib-config was correct, then it is best\n");
      printf ("*** to remove the old version of GLIB. You may also be able to fix the error\n");
      printf("*** by modifying your LD_LIBRARY_PATH enviroment variable, or by editing\n");
      printf("*** /etc/ld.so.conf. Make sure you have run ldconfig if that is\n");
      printf("*** required on your system.\n");
      printf("*** If glib-config was wrong, set the environment variable GLIB_CONFIG\n");
      printf("*** to point to the correct copy of glib-config, and remove the file config.cache\n");
      printf("*** before re-running configure\n");
    } 
  else if ((glib_major_version != GLIB_MAJOR_VERSION) ||
	   (glib_minor_version != GLIB_MINOR_VERSION) ||
           (glib_micro_version != GLIB_MICRO_VERSION))
    {
      printf("*** GLIB header files (version %d.%d.%d) do not match\n",
	     GLIB_MAJOR_VERSION, GLIB_MINOR_VERSION, GLIB_MICRO_VERSION);
      printf("*** library (version %d.%d.%d)\n",
	     glib_major_version, glib_minor_version, glib_micro_version);
    }
  else
    {
      if ((glib_major_version > major) ||
        ((glib_major_version == major) && (glib_minor_version > minor)) ||
        ((glib_major_version == major) && (glib_minor_version == minor) && (glib_micro_version >= micro)))
      {
        return 0;
       }
     else
      {
        printf("\n*** An old version of GLIB (%d.%d.%d) was found.\n",
               glib_major_version, glib_minor_version, glib_micro_version);
        printf("*** You need a version of GLIB newer than %d.%d.%d. The latest version of\n",
	       major, minor, micro);
        printf("*** GLIB is always available from ftp://ftp.gtk.org.\n");
        printf("***\n");
        printf("*** If you have already installed a sufficiently new version, this error\n");
        printf("*** probably means that the wrong copy of the glib-config shell script is\n");
        printf("*** being found. The easiest way to fix this is to remove the old version\n");
        printf("*** of GLIB, but you can also set the GLIB_CONFIG environment to point to the\n");
        printf("*** correct copy of glib-config. (In this case, you will have to\n");
        printf("*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n");
        printf("*** so that the correct libraries are found at run-time))\n");
      }
    }
  return 1;
}
],, no_glib=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
       CFLAGS="$ac_save_CFLAGS"
       LIBS="$ac_save_LIBS"
     fi
  fi
  if test "x$no_glib" = x ; then
     AC_MSG_RESULT(yes)
     ifelse([$2], , :, [$2])     
  else
     AC_MSG_RESULT(no)
     if test "$GLIB_CONFIG" = "no" ; then
       echo "*** The glib-config script installed by GLIB could not be found"
       echo "*** If GLIB was installed in PREFIX, make sure PREFIX/bin is in"
       echo "*** your path, or set the GLIB_CONFIG environment variable to the"
       echo "*** full path to glib-config."
     else
       if test -f conf.glibtest ; then
        :
       else
          echo "*** Could not run GLIB test program, checking why..."
          CFLAGS="$CFLAGS $GLIB_CFLAGS"
          LIBS="$LIBS $GLIB_LIBS"
          AC_TRY_LINK([
#include <glib.h>
#include <stdio.h>
],      [ return ((glib_major_version) || (glib_minor_version) || (glib_micro_version)); ],
        [ echo "*** The test program compiled, but did not run. This usually means"
          echo "*** that the run-time linker is not finding GLIB or finding the wrong"
          echo "*** version of GLIB. If it is not finding GLIB, you'll need to set your"
          echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point"
          echo "*** to the installed location  Also, make sure you have run ldconfig if that"
          echo "*** is required on your system"
	  echo "***"
          echo "*** If you have an old version installed, it is best to remove it, although"
          echo "*** you may also be able to get things to work by modifying LD_LIBRARY_PATH"
          echo "***"
          echo "*** If you have a RedHat 5.0 system, you should remove the GTK package that"
          echo "*** came with the system with the command"
          echo "***"
          echo "***    rpm --erase --nodeps gtk gtk-devel" ],
        [ echo "*** The test program failed to compile or link. See the file config.log for the"
          echo "*** exact error that occured. This usually means GLIB was incorrectly installed"
          echo "*** or that you have moved GLIB since it was installed. In the latter case, you"
          echo "*** may want to edit the glib-config script: $GLIB_CONFIG" ])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
       fi
     fi
     GLIB_CFLAGS=""
     GLIB_LIBS=""
     ifelse([$3], , :, [$3])
  fi
  AC_SUBST(GLIB_CFLAGS)
  AC_SUBST(GLIB_LIBS)
  rm -f conf.glibtest
])

# Configure paths for libcdaudio                -*- Autoconf -*-
#
# Derived from glib.m4 (Owen Taylor 97-11-3)
#

dnl AM_PATH_LIBCDAUDIO([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND ]]])
dnl Test for libcdaudio, and define LIBCDAUDIO_CFLAGS, LIBCDAUDIO_LIBS and
dnl LIBCDAUDIO_LDADD
dnl
AC_DEFUN([AM_PATH_LIBCDAUDIO],
[dnl 
dnl Get the cflags and libraries from the libcdaudio-config script
dnl
AC_ARG_WITH(libcdaudio-prefix,
            AS_HELP_STRING([--with-libcdaudio-prefix=PFX],
                           [Prefix where libcdaudio is installed (optional)]),
            [libcdaudio_config_prefix="$withval"], [libcdaudio_config_prefix=""])
AC_ARG_WITH(libcdaudio-exec-prefix,
            AS_HELP_STRING([--with-libcdaudio-exec-prefix=PFX],
                           [Exec prefix where libcdaudio is installed (optional)]),
            [libcdaudio_config_exec_prefix="$withval"],
            [libcdaudio_config_exec_prefix=""])
AC_ARG_ENABLE(libcdaudiotest,
              AS_HELP_STRING([--disable-libcdaudiotest],
	                     [Do not try to compile and run a test libcdaudio program]),,
	      [enable_libcdaudiotest=yes])

  if test "x$libcdaudio_config_exec_prefix" != x ; then
     libcdaudio_config_args="$libcdaudio_config_args --exec-prefix=$libcdaudio_config_exec_prefix"
     if test "x${LIBCDAUDIO_CONFIG+set}" != xset ; then
        LIBCDAUDIO_CONFIG=$libcdaudio_config_exec_prefix/bin/libcdaudio-config
     fi
  fi
  if test x$libcdaudio_config_prefix != x ; then
     libcdaudio_config_args="$libcdaudio_config_args --prefix=$libcdaudio_config_prefix"
     if test "x${LIBCDAUDIO_CONFIG+set}" != xset ; then
        LIBCDAUDIO_CONFIG=$libcdaudio_config_prefix/bin/libcdaudio-config
     fi
  fi

  AC_PATH_PROG(LIBCDAUDIO_CONFIG, libcdaudio-config, no)
  min_libcdaudio_version=ifelse([$1], ,0.99.0,$1)
  AC_MSG_CHECKING([for libcdaudio - version >= $min_libcdaudio_version])
  no_libcdaudio=""
  if test "$LIBCDAUDIO_CONFIG" = "no" ; then
    no_libcdaudio=yes
  else
    LIBCDAUDIO_CFLAGS=`$LIBCDAUDIO_CONFIG $libcdaudio_config_args --cflags`
    LIBCDAUDIO_LIBS=`$LIBCDAUDIO_CONFIG $libcdaudio_config_args --libs`
    LIBCDAUDIO_LDADD=`$LIBCDAUDIO_CONFIG $libcdaudio_config_args --ldadd`
    libcdaudio_config_major_version=`$LIBCDAUDIO_CONFIG $libcdaudio_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\).*/\1/'`
    libcdaudio_config_minor_version=`$LIBCDAUDIO_CONFIG $libcdaudio_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\).*/\2/'`
    libcdaudio_config_micro_version=`$LIBCDAUDIO_CONFIG $libcdaudio_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\).*/\3/'`
    if test "x$enable_libcdaudiotest" = "xyes" ; then
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $LIBCDAUDIO_CFLAGS $LIBCDAUDIO_LDADD"
      LIBS="$LIBCDAUDIO_LIBS $LIBS"
dnl
dnl Now check if the installed libcdaudio is sufficiently new. (Also sanity
dnl checks the results of libcdaudio-config to some extent
dnl
      rm -f conf.cdaudiotest
      AC_TRY_RUN([
#include <cdaudio.h>
#include <stdio.h>
#include <stdlib.h>

char* my_strdup (char *str)
{
  char *new_str;

  if (str) {
    new_str = malloc ((strlen (str) + 1) * sizeof(char));
    strcpy (new_str, str);
  } else
    new_str = NULL;

  return new_str;
}

int main()
{
  int major,minor,micro;
  int libcdaudio_major_version,libcdaudio_minor_version,libcdaudio_micro_version;
  char *tmp_version;

  system ("touch conf.cdaudiotest");

  /* HP/UX 9 (%@#!) writes to sscanf strings */
  tmp_version = my_strdup("$min_libcdaudio_version");
  if (sscanf(tmp_version, "%d.%d.%d", &major, &minor, &micro) != 3) {
     printf("%s, bad version string\n", "$min_libcdaudio_version");
     exit(1);
   }

  libcdaudio_major_version=(cdaudio_getversion()>>16)&255;
  libcdaudio_minor_version=(cdaudio_getversion()>> 8)&255;
  libcdaudio_micro_version=(cdaudio_getversion()    )&255;

  if ((libcdaudio_major_version != $libcdaudio_config_major_version) ||
      (libcdaudio_minor_version != $libcdaudio_config_minor_version) ||
      (libcdaudio_micro_version != $libcdaudio_config_micro_version))
    {
      printf("\n*** 'libcdaudio-config --version' returned %d.%d.%d, but libcdaudio (%d.%d.%d)\n", 
             $libcdaudio_config_major_version, $libcdaudio_config_minor_version, $libcdaudio_config_micro_version,
             libcdaudio_major_version, libcdaudio_minor_version, libcdaudio_micro_version);
      printf ("*** was found! If libcdaudio-config was correct, then it is best\n");
      printf ("*** to remove the old version of libcdaudio. You may also be able to fix the error\n");
      printf("*** by modifying your LD_LIBRARY_PATH enviroment variable, or by editing\n");
      printf("*** /etc/ld.so.conf. Make sure you have run ldconfig if that is\n");
      printf("*** required on your system.\n");
      printf("*** If libcdaudio-config was wrong, set the environment variable LIBCDAUDIO_CONFIG\n");
      printf("*** to point to the correct copy of libcdaudio-config, and remove the file config.cache\n");
      printf("*** before re-running configure\n");
    } 
  else if ((libcdaudio_major_version != LIBCDAUDIO_VERSION_MAJOR) ||
	   (libcdaudio_minor_version != LIBCDAUDIO_VERSION_MINOR) ||
           (libcdaudio_micro_version != LIBCDAUDIO_VERSION_MICRO))
    {
      printf("*** libcdaudio header files (version %d.%d.%d) do not match\n",
	     LIBCDAUDIO_VERSION_MAJOR, LIBCDAUDIO_VERSION_MINOR, LIBCDAUDIO_VERSION_MICRO);
      printf("*** library (version %d.%d.%d)\n",
	     libcdaudio_major_version, libcdaudio_minor_version, libcdaudio_micro_version);
    }
  else
    {
      if ((libcdaudio_major_version > major) ||
        ((libcdaudio_major_version == major) && (libcdaudio_minor_version > minor)) ||
        ((libcdaudio_major_version == major) && (libcdaudio_minor_version == minor) && (libcdaudio_micro_version >= micro)))
      {
        return 0;
       }
     else
      {
        printf("\n*** An old version of libcdaudio (%d.%d.%d) was found.\n",
               libcdaudio_major_version, libcdaudio_minor_version, libcdaudio_micro_version);
        printf("*** You need a version of libcdaudio newer than %d.%d.%d.\n",
	       major, minor, micro);
        printf("***\n");
        printf("*** If you have already installed a sufficiently new version, this error\n");
        printf("*** probably means that the wrong copy of the libcdaudio-config shell script is\n");
        printf("*** being found. The easiest way to fix this is to remove the old version\n");
        printf("*** of libcdaudio, but you can also set the LIBCDAUDIO_CONFIG environment to point to the\n");
        printf("*** correct copy of libcdaudio-config. (In this case, you will have to\n");
        printf("*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n");
        printf("*** so that the correct libraries are found at run-time))\n");
      }
    }
  return 1;
}
],, no_libcdaudio=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
       CFLAGS="$ac_save_CFLAGS"
       LIBS="$ac_save_LIBS"
     fi
  fi
  if test "x$no_libcdaudio" = x ; then
     AC_MSG_RESULT(yes)
     ifelse([$2], , :, [$2])     
  else
     AC_MSG_RESULT(no)
     if test "$LIBCDAUDIO_CONFIG" = "no" ; then
       echo "*** The libcdaudio-config script installed by libcdaudio could not be found"
       echo "*** If libcdaudio was installed in PREFIX, make sure PREFIX/bin is in"
       echo "*** your path, or set the LIBCDAUDIO_CONFIG environment variable to the"
       echo "*** full path to libcdaudio-config."
     else
       if test -f conf.cdaudiotest ; then
        :
       else
          echo "*** Could not run libcdaudio test program, checking why..."
          CFLAGS="$CFLAGS $LIBCDAUDIO_CFLAGS"
          LIBS="$LIBS $LIBCDAUDIO_LIBS"
          AC_TRY_LINK([
#include <cdaudio.h>
#include <stdio.h>
],      [ return (cdaudio_getversion()!=0); ],
        [ echo "*** The test program compiled, but did not run. This usually means"
          echo "*** that the run-time linker is not finding libcdaudio or finding the wrong"
          echo "*** version of libcdaudio. If it is not finding libcdaudio, you'll need to set your"
          echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point"
          echo "*** to the installed location. Also, make sure you have run ldconfig if that"
          echo "*** is required on your system"
	  echo "***"
          echo "*** If you have an old version installed, it is best to remove it, although"
          echo "*** you may also be able to get things to work by modifying LD_LIBRARY_PATH"],
        [ echo "*** The test program failed to compile or link. See the file config.log for the"
          echo "*** exact error that occured. This usually means libcdaudio was incorrectly installed"
          echo "*** or that you have moved libcdaudio since it was installed. In the latter case, you"
          echo "*** may want to edit the libcdaudio-config script: $LIBCDAUDIO_CONFIG" ])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
       fi
     fi
     LIBCDAUDIO_CFLAGS=""
     LIBCDAUDIO_LIBS=""
     LIBCDAUDIO_LDADD=""
     ifelse([$3], , :, [$3])
  fi
  AC_SUBST(LIBCDAUDIO_CFLAGS)
  AC_SUBST(LIBCDAUDIO_LIBS)
  AC_SUBST(LIBCDAUDIO_LDADD)
  rm -f conf.cdaudiotest
])

