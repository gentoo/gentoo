# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=5.00
DIST_AUTHOR=SIFUKURT
inherit perl-module

DESCRIPTION="Collection of useful math-related functions"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.470.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
