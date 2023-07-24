# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=IVAN
DIST_VERSION=0.47
inherit perl-module

DESCRIPTION="Database-independent schema objects"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~riscv x86"

RDEPEND="
	dev-perl/DBI
	virtual/perl-Storable
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
