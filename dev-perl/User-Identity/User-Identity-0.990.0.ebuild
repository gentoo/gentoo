# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=0.99
inherit perl-module

DESCRIPTION="Maintains info about a physical person"

SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="test"

RDEPEND="
	!<dev-perl/Geography-Countries-1.400.0
"
#	dev-perl/TimeDate
#	dev-perl/Geography-Countries
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
