# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DSLEWART
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="wrapper to libm functions"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
