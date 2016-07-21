# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

export CTARGET=hppa64-${CHOST#*-}

PATCHVER="1.2"
ELF2FLT_VER=""
inherit toolchain-binutils

DESCRIPTION="binutils package for building 64bit kernels on HPPA"

KEYWORDS="-* hppa"

# 66_all_binutils-2.22-warn-textrel.patch fails to apply with
# patch-2.5.9, so require a version that for sure works
DEPEND+=" >=sys-devel/patch-2.6.1"

src_install() {
	toolchain-binutils_src_install

	# tweak the default fake list a little bit
	cd "${D}"/etc/env.d/binutils
	sed -i '/FAKE_TARGETS=/s:"$: hppa64-linux":' ${CTARGET}-${BVER} || die
}
