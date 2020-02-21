# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.104
inherit perl-module

DESCRIPTION="Find and Format Date Headers"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/TimeDate-1.16
	>=dev-perl/Email-Abstract-2.13.1
	>=dev-perl/Email-Date-Format-1.0.0
	>=virtual/perl-Time-Piece-1.80.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Time-Local
		dev-perl/Capture-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)
"
