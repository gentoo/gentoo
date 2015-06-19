# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.2.4-r1.ebuild,v 1.21 2015/05/05 06:53:03 vapier Exp $

EAPI="5"

PATCH_VER="1.3"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~m68k ~ppc ~ppc64 ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
