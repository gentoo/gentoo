# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Maintains info about a physical person"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ppc64 x86"

RDEPEND="
	!<dev-perl/Geography-Countries-1.400.0
"
#	dev-perl/TimeDate
#	dev-perl/Geography-Countries
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
