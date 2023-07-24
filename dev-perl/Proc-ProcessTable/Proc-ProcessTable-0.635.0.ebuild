# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JWB
DIST_VERSION=0.635
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Unix process table information"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv sparc x86"
IUSE="examples"

RDEPEND="
	virtual/perl-Storable
"
DEPEND="elibc_musl? ( sys-libs/obstack-standalone )"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}/amd64_canonicalize_file_name_definition.patch"
)
