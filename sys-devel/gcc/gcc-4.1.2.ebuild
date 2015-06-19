# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.1.2.ebuild,v 1.42 2015/05/05 06:53:03 vapier Exp $

EAPI="5"

PATCH_VER="1.5"
UCLIBC_VER="1.0"
D_VER="0.24"

inherit eutils toolchain

KEYWORDS="-* alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~sparc-fbsd ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0

	# Fix cross-compiling
	epatch "${FILESDIR}"/4.1.0/gcc-4.1.0-cross-compile.patch

	epatch "${FILESDIR}"/4.1.0/gcc-4.1.0-fast-math-i386-Os-workaround.patch
}
