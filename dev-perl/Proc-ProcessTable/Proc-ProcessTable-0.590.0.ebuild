# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JWB
DIST_VERSION=0.59
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Unix process table information"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

PATCHES=(
	"${FILESDIR}/amd64_canonicalize_file_name_definition.patch"
)

RDEPEND="
	virtual/perl-Storable
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
