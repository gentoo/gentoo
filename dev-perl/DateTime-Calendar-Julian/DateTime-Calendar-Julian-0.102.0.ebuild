# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=WYANT
DIST_VERSION=0.102
inherit perl-module

DESCRIPTION="Dates in the Julian calendar"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/DateTime-0.80.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
