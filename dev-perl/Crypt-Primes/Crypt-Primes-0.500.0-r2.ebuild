# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=VIPUL
DIST_VERSION=0.50
inherit perl-module

DESCRIPTION="Provable Prime Number Generator suitable for Cryptographic Applications"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~sparc x86"

RDEPEND="
	>=dev-perl/Math-Pari-2.1.804
	>=dev-perl/Crypt-Random-0.330.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
