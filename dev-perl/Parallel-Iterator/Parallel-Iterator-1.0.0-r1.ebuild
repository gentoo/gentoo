# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ANDYA
DIST_VERSION=1.00
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Simple parallel execution"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-IO
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
PATCHES=("${FILESDIR}/${PN}-1.00-perl-5.26.patch")
