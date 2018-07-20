# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

case ${CHOST} in
	hppa*)    CTARGET=hppa64-${CHOST#*-};;
	mips*)    CTARGET=${CHOST/mips/mips64};;
	powerpc*) CTARGET=${CHOST/powerpc/powerpc64};;
	s390*)    CTARGET=${CHOST/s390/s390x};;
	sparc*)   CTARGET=${CHOST/sparc/sparc64};;
	i?86*)    CTARGET=x86_64-${CHOST#*-};;
esac
export CTARGET
TOOLCHAIN_ALLOWED_LANGS="c"
GCC_TARGET_NO_MULTILIB=true

PATCH_VER="1.0"
inherit eutils toolchain

DESCRIPTION="64bit kernel compiler"

# Works on hppa and mips; all other archs, refer to bug #228115
KEYWORDS="~hppa ~mips"

RDEPEND=">=dev-libs/gmp-4.3.2
	>=dev-libs/mpfr-2.4.2
	>=dev-libs/mpc-0.8.1
	>=sys-devel/gcc-config-1.4"
# unlike every other target, hppa has not unified the 32/64 bit
# ports in binutils yet
DEPEND="${RDEPEND}
	hppa? ( sys-devel/binutils-hppa64 )
	!sys-devel/gcc-hppa64
	!sys-devel/gcc-mips64
	!sys-devel/gcc-powerpc64
	!sys-devel/gcc-sparc64
	>=sys-apps/texinfo-4.8
	>=sys-devel/bison-1.875"

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
