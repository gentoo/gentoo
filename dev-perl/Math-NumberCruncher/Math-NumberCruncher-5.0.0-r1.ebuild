# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=5.00
DIST_AUTHOR=SIFUKURT
inherit perl-module

DESCRIPTION="Collection of useful math-related functions"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/perl-Math-BigInt-1.470.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
