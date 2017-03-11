# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MITHALDU
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Diffie-Hellman key exchange system"

SLOT="0"
KEYWORDS="amd64 hppa ~mips x86"
IUSE=""

RDEPEND="
	dev-libs/gmp
	dev-perl/Math-BigInt-GMP
	>=virtual/perl-Math-BigInt-1.60
	dev-perl/Crypt-Random
"
DEPEND="${RDEPEND}"
