# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=1.57
inherit perl-module

DESCRIPTION="Cryptographically Secure, True Random Number Generator"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/Class-Loader-2.0.0
	dev-perl/Crypt-URandom
	>=dev-perl/Math-Pari-2.1.804
	>=dev-perl/Statistics-ChiSquare-1.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}/${P}-division.patch"
)
