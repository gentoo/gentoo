# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PJACKLAM
MODULE_VERSION=1.38
inherit perl-module

DESCRIPTION="Use the GMP library for Math::BigInt routines"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

RDEPEND=">=virtual/perl-Math-BigInt-1.999.300
	 >=dev-libs/gmp-4.0.0:0"
DEPEND="${RDEPEND}"

SRC_TEST="do"
