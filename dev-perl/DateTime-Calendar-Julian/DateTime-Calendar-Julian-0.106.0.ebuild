# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=WYANT
DIST_VERSION=0.106
inherit perl-module

DESCRIPTION="Dates in the Julian calendar"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="
	>=dev-perl/DateTime-0.80.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
