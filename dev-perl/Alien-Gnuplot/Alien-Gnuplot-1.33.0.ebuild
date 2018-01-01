# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
