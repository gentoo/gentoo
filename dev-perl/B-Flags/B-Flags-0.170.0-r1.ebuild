# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RURBAN
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Friendlier flags for B"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
