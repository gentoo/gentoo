# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=1.5
inherit perl-module

DESCRIPTION="A Perl interface to the uulib library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-unbundle.patch" )

RDEPEND="
	>=dev-libs/uulib-0.5.20-r1
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/Canary-Stability
"

SRC_TEST="do parallel"
