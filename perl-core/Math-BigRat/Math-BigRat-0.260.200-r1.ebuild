# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Math-BigRat/Math-BigRat-0.260.200-r1.ebuild,v 1.2 2014/11/08 16:05:06 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PJACKLAM
MODULE_VERSION=0.2602
inherit perl-module

DESCRIPTION="Arbitrary big rational numbers"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/perl-Math-BigInt-1.991"
RDEPEND="${DEPEND}"

SRC_TEST="do"
