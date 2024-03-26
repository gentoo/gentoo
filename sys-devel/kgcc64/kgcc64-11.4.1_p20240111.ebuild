# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

case ${CHOST} in
	hppa*)    CTARGET=hppa64-${CHOST#*-};;
	mips*)    CTARGET=${CHOST/mips/mips64};;
	powerpc*) CTARGET=${CHOST/powerpc/powerpc64};;
	s390*)    CTARGET=${CHOST/s390/s390x};;
	sparc*)   CTARGET=${CHOST/sparc/sparc64};;
	i?86*)    CTARGET=x86_64-${CHOST#*-};;
esac
export CTARGET

GCC_TARGET_NO_MULTILIB=true
TOOLCHAIN_ALLOWED_LANGS="c"
TOOLCHAIN_PATCH_DEV="sam"
PATCH_GCC_VER="11.4.0"
PATCH_VER="12"
MUSL_VER="2"
MUSL_GCC_VER="11.4.0"
PYTHON_COMPAT=( python3_{10..11} )
inherit toolchain

DESCRIPTION="64bit kernel compiler"

# Works on hppa and mips; all other archs, refer to bug #228115
KEYWORDS="hppa"

# unlike every other target, hppa has not unified the 32/64 bit
# ports in binutils yet
BDEPEND="hppa? ( sys-devel/binutils-hppa64 )"

pkg_postinst() {
	toolchain_pkg_postinst

	cd "${ROOT}"/usr/bin
	local x
	for x in gcc cpp ; do
		cat <<-EOF >${CTARGET%%-*}-linux-${x}
		#!/bin/sh
		exec ${CTARGET}-${x} "\$@"
		EOF
		chmod a+rx ${CTARGET%%-*}-linux-${x}
	done
}
