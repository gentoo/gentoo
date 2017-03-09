# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PJACKLAM
MODULE_VERSION=1.9993
inherit perl-module eutils

DESCRIPTION="Arbitrary size floating point math package"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ~s390 ~sh sparc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/perl-Scalar-List-Utils-1.140.0"
DEPEND="${RDEPEND}"

PDEPEND=">=virtual/perl-Math-BigInt-FastCalc-0.270.0
	>=virtual/perl-bignum-0.220.0
	>=virtual/perl-Math-BigRat-0.260.200"

SRC_TEST="do"
