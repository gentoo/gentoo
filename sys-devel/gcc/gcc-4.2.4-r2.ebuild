# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.5"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
