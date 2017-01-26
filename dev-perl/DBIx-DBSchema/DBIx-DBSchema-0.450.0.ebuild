# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=IVAN
MODULE_VERSION=0.45
inherit perl-module

DESCRIPTION="Database-independent schema objects"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="
	dev-perl/DBI
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
