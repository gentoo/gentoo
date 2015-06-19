# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/bignum/bignum-0.320.0.ebuild,v 1.4 2014/11/08 17:09:45 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=FLORA
MODULE_VERSION=0.32
inherit perl-module

DESCRIPTION="Transparent BigNumber/BigRational support for Perl"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=virtual/perl-Math-BigInt-1.880.0
	>=virtual/perl-Math-BigRat-0.210.0
"
DEPEND="${RDEPEND}"
#	test? (
#		dev-perl/Test-Pod
#		>=dev-perl/Test-Pod-Coverage-1.08
#	)
#"

SRC_TEST="do"
