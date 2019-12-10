# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAVID
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="A clock source that only increments and never jumps"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.400
	virtual/perl-ExtUtils-CBuilder
	test? ( virtual/perl-Test-Simple )
"
