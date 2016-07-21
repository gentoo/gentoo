# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

export CTARGET=hppa64-${CHOST#*-}

PATCHVER="1.1"
ELF2FLT_VER=""
inherit toolchain-binutils

DESCRIPTION="binutils package for building 64bit kernels on HPPA"

KEYWORDS="-* hppa"

src_install() {
	toolchain-binutils_src_install

	# tweak the default fake list a little bit
	cd "${D}"/etc/env.d/binutils
	sed -i '/FAKE_TARGETS=/s:"$: hppa64-linux":' ${CTARGET}-${BVER} || die
}
