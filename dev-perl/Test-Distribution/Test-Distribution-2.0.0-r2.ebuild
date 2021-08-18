# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SRSHAH
DIST_VERSION=2.00
inherit perl-module

DESCRIPTION="perform tests on all modules of a distribution"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	>=dev-perl/Pod-Coverage-0.200.0
	>=dev-perl/File-Find-Rule-0.300.0
	dev-perl/Test-Pod-Coverage
	>=virtual/perl-Module-CoreList-2.170.0
	>=dev-perl/Test-Pod-1.260.0

"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
