# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MRSAM
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Manipulate netblock lists in CIDR notation"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
