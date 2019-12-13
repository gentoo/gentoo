# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.000014
inherit perl-module

DESCRIPTION="Read MaxMind DB files and look up IP addresses"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Data-IEEE754
	dev-perl/Data-Printer
	>=dev-perl/Data-Validate-IP-0.250.0
	dev-perl/List-AllUtils
	>=dev-perl/MaxMind-DB-Common-0.40.1
	>=dev-perl/Moo-1.3.0
	dev-perl/MooX-StrictConstructor
	dev-perl/namespace-autoclean
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Path-Class-0.270.0
		dev-perl/Test-Bits
		dev-perl/Test-Number-Delta
		dev-perl/Test-Requires
	)
"
