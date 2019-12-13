# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Sane APIs for IP addresses and networks"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/List-AllUtils
	>=dev-perl/Math-Int128-0.60.0
	dev-perl/Moo
	dev-perl/namespace-autoclean
	dev-perl/Sub-Quote
"
DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Fatal )"
