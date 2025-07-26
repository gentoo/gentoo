# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NUFFIN
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Figure out the names of variables passed into subroutines"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/PadWalker"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)
"
