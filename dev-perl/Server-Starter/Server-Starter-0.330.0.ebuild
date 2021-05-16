# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.33
inherit perl-module

DESCRIPTION="A superdaemon for hot-deploying server programs"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.500
	test? (
		virtual/perl-IO-Socket-IP
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
		>=dev-perl/Test-TCP-2.130.0
	)
"

PATCHES=( "${FILESDIR}/${P}-perl526.patch" )
