# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-BigInt-GMP/Math-BigInt-GMP-1.380.0.ebuild,v 1.4 2014/08/02 20:06:25 zlogene Exp $

EAPI=5

MODULE_AUTHOR=PJACKLAM
MODULE_VERSION=1.38
inherit perl-module

DESCRIPTION="Use the GMP library for Math::BigInt routines"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

RDEPEND=">=virtual/perl-Math-BigInt-1.999.300
	 >=dev-libs/gmp-4.0.0"
DEPEND="${RDEPEND}"

SRC_TEST="do"
