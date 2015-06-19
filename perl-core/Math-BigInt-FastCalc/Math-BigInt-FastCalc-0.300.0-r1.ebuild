# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Math-BigInt-FastCalc/Math-BigInt-FastCalc-0.300.0-r1.ebuild,v 1.2 2015/06/07 14:43:01 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PJACKLAM
MODULE_VERSION=0.30
inherit perl-module

DESCRIPTION="Math::BigInt::Calc with some XS for more speed"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/perl-Math-BigInt-1.997.0
	virtual/perl-XSLoader"
DEPEND="${RDEPEND}"

SRC_TEST="do"
