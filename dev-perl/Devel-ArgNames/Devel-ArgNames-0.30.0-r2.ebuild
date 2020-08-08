# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NUFFIN
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Figure out the names of variables passed into subroutines"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/PadWalker"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)
"
