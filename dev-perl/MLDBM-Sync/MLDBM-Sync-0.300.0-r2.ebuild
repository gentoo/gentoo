# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHAMAS
DIST_VERSION=0.30
inherit perl-module

DESCRIPTION="Safe concurrent access to MLDBM databases"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	dev-perl/MLDBM
	dev-perl/Tie-Cache
"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Harness )
"

# parallel testing fails
DIST_TEST=do
