# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MENDEL
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="URI for Redis connection info"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/URI
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		>=dev-perl/Test-Most-0.210.0
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.02-no-dot-inc.patch" )
