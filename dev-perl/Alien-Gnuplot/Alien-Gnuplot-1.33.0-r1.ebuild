# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=1.033
DIST_AUTHOR=ZOWIE
inherit perl-module

DESCRIPTION="Find and verify functionality of the gnuplot executable"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-HTTP-Tiny
	virtual/perl-Time-HiRes
	sci-visualization/gnuplot
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=( "${FILESDIR}/${P}-version.patch" )
