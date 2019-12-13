# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.000008
inherit perl-module

DESCRIPTION="Fast XS implementation of MaxMind DB reader"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libmaxminddb:=
	dev-perl/Math-Int128
	dev-perl/MaxMind-DB-Reader
	dev-perl/Moo
	dev-perl/Net-Works
	dev-perl/namespace-autoclean
"
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-MakeMaker
"
