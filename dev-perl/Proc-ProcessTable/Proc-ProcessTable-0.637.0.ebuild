# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JWB
DIST_VERSION=0.637
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Unix process table information"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples"

DEPEND="elibc_musl? ( sys-libs/obstack-standalone )"
