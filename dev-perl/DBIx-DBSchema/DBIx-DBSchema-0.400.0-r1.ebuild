# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=IVAN
MODULE_VERSION=0.40
inherit perl-module

DESCRIPTION="Database-independent schema objects"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="dev-perl/DBI
	dev-perl/FreezeThaw
	virtual/perl-Storable"
DEPEND="${RDEPEND}"

SRC_TEST="do"
