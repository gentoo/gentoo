# -*- mode: shell-script; -*-
# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# RAP specific patches pending upstream:
# binutils: http://article.gmane.org/gmane.comp.gnu.binutils/67593
# gcc: https://gcc.gnu.org/ml/gcc-patches/2014-12/msg00331.html

# Disable RAP trick during bootstrap stage2
[[ -z ${BOOTSTRAP_RAP_STAGE2} ]] || return 0

if [[ ${CATEGORY}/${PN} == sys-devel/binutils && ${EBUILD_PHASE} == prepare ]]; then
    ebegin "Prefixifying native library path"
    sed -i -r "/NATIVE_LIB_DIRS/s,((/usr(/local|)|)/lib),${EPREFIX}\1,g" \
	"${S}"/ld/configure.tgt
    eend $?
elif [[ ${CATEGORY}/${PN} == sys-libs/glibc && ${EBUILD_PHASE} == configure ]]; then
    cd "${S}"
    einfo "Prefixifying hardcoded path"

    for f in libio/iopopen.c \
		 shadow/lckpwdf.c resolv/{netdb,resolv}.h elf/rtld.c \
		 nis/nss_compat/compat-{grp,initgroups,{,s}pwd}.c \
		 nss/{bug-erange,nss_files/files-{XXX,init{,groups}}}.c \
		 sysdeps/{{generic,unix/sysv/linux}/paths.h,posix/system.c}
    do
	ebegin "  Updating $f"
	sed -i -r "s,([:\"])/(etc|usr|bin|var),\1${EPREFIX}/\2,g" $f
	eend $?
    done
    ebegin "  Updating nss/db-Makefile"
    sed -i -r \
	-e "s,/(etc|var),${EPREFIX}/\1,g" \
	nss/db-Makefile
    eend $?
elif [[ ${CATEGORY}/${PN} == dev-lang/perl && ${EBUILD_PHASE} == configure ]]; then
    ebegin "Prefixifying pwd path"
    sed -r "s,'((|/usr)/bin/pwd),'${EPREFIX}\1," -i "${S}"/dist/PathTools/Cwd.pm
    eend $?

    # Configure checks for /system/lib/libandroid.so to override linux into linux-android,
    # which is not desired for Gentoo
    ebegin "Removing Android detection"
    sed "/libandroid.so/d" -i "${S}"/Configure
    eend $?
elif [[ ${CATEGORY}/${PN} == sys-devel/make && ${EBUILD_PHASE} == prepare ]]; then
    ebegin "Prefixifying default shell"
    sed -i -r "/default_shell/s,\"(/bin/sh),\"${EPREFIX}\1," "${S}"/job.c
    eend $?
elif [[ ${CATEGORY}/${PN} == sys-libs/zlib && ${EBUILD_PHASE} == prepare ]]; then
    [[ -n "${BOOTSTRAP_RAP}" ]] || return 0
    ebegin "Remove executable builds for bootstrap"
    sed -i 's/ALL=.*/ALL="\\$(LIBS)"/' "${S}"/configure
    eend $?
elif [[ ${CATEGORY}/${PN} == dev-lang/php && ${EBUILD_PHASE} == prepare ]]; then
    # introduced in bug 419525, subtle glibc location difference.
    ebegin "Prefixifying ext/iconv/config.m4 paths"
    sed -i -r "/for i in/s,(/usr(/local|)),${EPREFIX}\1,g" "${S}"/ext/iconv/config.m4
    eend $?
elif [[ ${CATEGORY}/${PN} == dev-util/cmake && ${EBUILD_PHASE} == prepare ]]; then
    einfo "Removing Debian magic..."
    for f in Modules/{CMakeFindPackageMode,FindPkgConfig,GNUInstallDirs,Platform/{GNU,Linux}}.cmake; do
	ebegin "  Updating $f"
	sed -i -e 's,EXISTS "/etc/debian_version",FALSE,' "${S}"/$f
	eend $?
    done
fi
