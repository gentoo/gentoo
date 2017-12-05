# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PJACKLAM
DIST_VERSION=1.49
inherit perl-module

DESCRIPTION="Use the GMP library for Math::BigInt routines"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.999.714
	>=virtual/perl-XSLoader-0.20.0
	>=dev-libs/gmp-4.0.0:0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
PATCHES=("${FILESDIR}/${P}-no-dot-inc.patch")
