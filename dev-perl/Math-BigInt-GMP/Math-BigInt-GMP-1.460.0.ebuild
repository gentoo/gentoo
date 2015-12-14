# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PJACKLAM
MODULE_VERSION=1.46
inherit perl-module

DESCRIPTION="Use the GMP library for Math::BigInt routines"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=virtual/perl-Math-BigInt-1.999.300
	 >=dev-libs/gmp-4.0.0"
DEPEND="${RDEPEND}"

PERL_RM_FILES=(
	t/bigfltpm.t
	t/bigintpm.t
	t/biglog.t
)

SRC_TEST="do"
