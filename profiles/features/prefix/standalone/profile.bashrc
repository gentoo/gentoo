# -*- mode: shell-script; -*-
# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# RAP specific patches pending upstream:
# binutils: http://article.gmane.org/gmane.comp.gnu.binutils/67593
# gcc: https://gcc.gnu.org/ml/gcc-patches/2014-12/msg00331.html

# Disable RAP trick during bootstrap stage2
[[ -z ${BOOTSTRAP_RAP_STAGE2} ]] || return 0

if [[ ${CATEGORY}/${PN} == sys-devel/gcc && ${EBUILD_PHASE} == configure ]]; then
    cd "${S}"
    einfo "Prefixifying dynamic linkers..."
    for h in gcc/config/*/*linux*.h; do
	ebegin "  Updating $h"
	sed -i -r "/_DYNAMIC_LINKER/s,([\":])(/lib),\1${EPREFIX}\2,g" $h
	eend $?
    done

    # use sysroot of toolchain to get correct include and library at compile time
    EXTRA_ECONF="${EXTRA_ECONF} --with-sysroot=${EPREFIX}"

    ebegin "remove --sysroot call on ld for native toolchain"
    sed -i 's/--sysroot=%R//' gcc/gcc.c
    eend $?
elif [[ ${CATEGORY}/${PN} == sys-devel/clang && ${EBUILD_PHASE} == configure ]]; then
    ebegin "Use ${EPREFIX} as default sysroot"
    sed -i -e "s@DEFAULT_SYSROOT \"\"@DEFAULT_SYSROOT \"${EPREFIX}\"@" "${S}"/CMakeLists.txt
    eend $?
    pushd "${S}/lib/Driver/ToolChains" >/dev/null
    ebegin "Use dynamic linker from ${EPREFIX}"
    sed -i -e "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX%/}/\"@" Linux.cpp
    eend $?
    ebegin "Remove --sysroot call on ld for native toolchain"
    sed -i -e "$(grep -n -B1 sysroot= Gnu.cpp | sed -ne '{1s/-.*//;1p}'),+1 d" Gnu.cpp
    eend $?
    popd >/dev/null
elif [[ ${CATEGORY}/${PN} == sys-devel/binutils && ${EBUILD_PHASE} == prepare ]]; then
    ebegin "Prefixifying native library path"
    sed -i -r "/NATIVE_LIB_DIRS/s,((/usr(/local|)|)/lib),${EPREFIX}\1,g" \
	"${S}"/ld/configure.tgt
    eend $?

    ebegin "Prefixifying path to /etc/ld.so.conf"
    local f=
    if [[ -f "${S}"/ld/emultempl/elf32.em ]]; then
        f="${S}"/ld/emultempl/elf32.em
    elif [[ -f "${S}"/ld/ldelf.c ]]; then
        f="${S}"/ld/ldelf.c
    fi
    [[ -n "${f}" ]] && sed -i -r "s,\"/etc,\"${EPREFIX}/etc," "${f}"
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
elif [[ ${CATEGORY}/${PN} == dev-lang/python && ${EBUILD_PHASE} == configure ]]; then
    # Guide h2py to look into glibc of Prefix
    ebegin "Guiding h2py to look into Prefix"
    export include="${EPREFIX}"/usr/include
    sed -i -r \
	-e "s,/usr/include,\"${EPREFIX}\"/usr/include,g" "${S}"/Lib/plat-linux*/regen
    eend $?
    ebegin "Prefixifying distutils paths"
    sed -re "s,([^[:alnum:]])(/usr[/[:alnum:]]*/(lib[[:alnum:]]*|include)|/lib[[:alnum:]]*),\1${EPREFIX}\2,g" \
	-i "${S}"/setup.py
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
fi
