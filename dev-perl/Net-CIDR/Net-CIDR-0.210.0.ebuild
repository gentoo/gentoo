# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MRSAM
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Manipulate netblock lists in CIDR notation"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~mips ppc ~ppc64 x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
