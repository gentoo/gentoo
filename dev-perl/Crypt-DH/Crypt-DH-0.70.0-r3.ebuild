# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MITHALDU
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Diffie-Hellman key exchange system"

SLOT="0"
KEYWORDS="amd64 ~hppa x86"

RDEPEND="
	dev-libs/gmp:0
	>=dev-perl/Math-BigInt-GMP-1.240.0
	>=virtual/perl-Math-BigInt-1.600.0
	dev-perl/Crypt-Random
"
DEPEND="dev-libs/gmp:0"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=(
	"${FILESDIR}/${PN}-0.07-no-dot-inc.patch"
)
