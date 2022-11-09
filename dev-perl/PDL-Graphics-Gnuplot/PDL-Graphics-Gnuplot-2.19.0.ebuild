# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=2.019
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Gnuplot-based plotting for PDL"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Alien-Gnuplot
	virtual/perl-IO
	dev-perl/IPC-Run
	virtual/perl-Scalar-List-Utils
	dev-perl/PDL
	dev-perl/PDL-Transform-Color
	dev-perl/Safe-Isa
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	|| ( sci-visualization/gnuplot[X] sci-visualization/gnuplot[qt4(-)] )
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? ( virtual/perl-Test-Simple )
"
