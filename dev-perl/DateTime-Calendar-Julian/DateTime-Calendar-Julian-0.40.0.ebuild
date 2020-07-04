# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PIJLL
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Dates in the Julian calendar"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/DateTime-0.80.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
