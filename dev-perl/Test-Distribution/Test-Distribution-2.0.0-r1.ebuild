# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SRSHAH
MODULE_VERSION=2.00
inherit perl-module

DESCRIPTION="perform tests on all modules of a distribution"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=dev-perl/Pod-Coverage-0.20
	>=dev-perl/File-Find-Rule-0.30
	dev-perl/Test-Pod-Coverage
	>=virtual/perl-Module-CoreList-2.17
	>=dev-perl/Test-Pod-1.26"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do
