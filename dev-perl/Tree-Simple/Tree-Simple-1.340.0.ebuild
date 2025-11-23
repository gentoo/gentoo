# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSAVAGE
DIST_VERSION=1.34
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="A simple tree object"

SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"
IUSE="minimal"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.180.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? ( dev-perl/Test-Memory-Cycle )
		>=dev-perl/Test-Exception-0.150.0
		>=virtual/perl-Test-Simple-1.1.2
	)
"
