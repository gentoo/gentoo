# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SMUELLER
MODULE_VERSION=0.1700
inherit perl-module

DESCRIPTION="XS for C++"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="
	>=dev-perl/Module-Build-0.400.0
	test? (
		dev-perl/Test-Differences
		dev-perl/Test-Base
	)
"
RDEPEND="
	>=virtual/perl-ExtUtils-ParseXS-2.22.02
"
PATCHES=( "${FILESDIR}/${P}-no-dot-inc.patch" )
SRC_TEST=do
