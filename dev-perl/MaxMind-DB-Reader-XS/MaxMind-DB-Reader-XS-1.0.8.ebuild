# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.000008
inherit perl-module

DESCRIPTION="Fast XS implementation of MaxMind DB reader"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-libs/libmaxminddb:=
	dev-perl/Math-Int128
	dev-perl/Math-Int64
	dev-perl/MaxMind-DB-Reader
	>=dev-perl/MaxMind-DB-Common-0.40.1
	dev-perl/Moo
	virtual/perl-XSLoader
	dev-perl/namespace-autoclean
"
DEPEND="
	>=dev-perl/Module-Build-0.280.0
	dev-libs/libmaxminddb:=
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/Module-Implementation
		>=dev-perl/Net-Works-0.210.0
		>=dev-perl/Path-Class-0.270.0
		dev-perl/Test-Fatal
		dev-perl/Test-Number-Delta
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-autodie
		virtual/perl-version
	)
"
