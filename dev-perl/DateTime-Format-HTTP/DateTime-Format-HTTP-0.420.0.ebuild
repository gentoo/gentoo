# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CKRAS
MODULE_VERSION=0.42
inherit perl-module

DESCRIPTION="Date conversion routines"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/DateTime-0.170.0
	>=dev-perl/HTTP-Date-1.440.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"

SRC_TEST=do
