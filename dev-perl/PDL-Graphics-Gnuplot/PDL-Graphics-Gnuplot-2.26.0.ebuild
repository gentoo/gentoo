# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=2.026
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Gnuplot-based plotting for PDL"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Alien-Gnuplot-1.31.0
	>=virtual/perl-File-Temp-0.190.0
	virtual/perl-IO
	dev-perl/IPC-Run
	virtual/perl-Scalar-List-Utils
	dev-perl/PDL
	dev-perl/PDL-Transform-Color
	dev-perl/Safe-Isa
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	sci-visualization/gnuplot
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? ( virtual/perl-Test-Simple )
"
