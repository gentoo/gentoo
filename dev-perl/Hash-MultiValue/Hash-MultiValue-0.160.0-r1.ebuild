# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ARISTOTLE
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Store multiple values per key"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
