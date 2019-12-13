# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=0.040001
inherit perl-module

DESCRIPTION="Code shared by the MaxMind DB reader and writer modules"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Data-Dumper-Concise
	dev-perl/DateTime
	dev-perl/List-AllUtils
	dev-perl/Moo
	dev-perl/MooX-StrictConstructor
	dev-perl/namespace-autoclean
	dev-perl/Sub-Quote
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
