# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=IVAN
DIST_VERSION=0.45
inherit perl-module

DESCRIPTION="Database-independent schema objects"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

RDEPEND="
	dev-perl/DBI
	virtual/perl-Storable
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
