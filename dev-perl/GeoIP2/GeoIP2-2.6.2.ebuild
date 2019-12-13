# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=2.006002
inherit perl-module

DESCRIPTION="API for MaxMind's GeoIP2 web services and databases"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Data-Validate-IP-0.250.0
	dev-perl/HTTP-Message
	dev-perl/JSON-MaybeXS
	dev-perl/libwww-perl
	dev-perl/List-AllUtils
	dev-perl/List-SomeUtils
	dev-perl/LWP-Protocol-https
	>=dev-perl/MaxMind-DB-Reader-1.0.0
	dev-perl/MaxMind-DB-Reader-XS
	dev-perl/Moo
	dev-perl/namespace-autoclean
	dev-perl/namespace-clean
	dev-perl/Params-Validate
	dev-perl/strictures
	dev-perl/Throwable
	dev-perl/URI
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Path-Class
		dev-perl/Test-Number-Delta
	)
"
