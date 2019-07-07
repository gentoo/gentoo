# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.5"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.15.94"
