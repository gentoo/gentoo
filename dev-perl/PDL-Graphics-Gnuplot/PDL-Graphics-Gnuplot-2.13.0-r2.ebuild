# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=2.013
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Gnuplot-based plotting for PDL"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

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
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? ( virtual/perl-Test-Simple )
"

PATCHES=(
	"${FILESDIR}/${P}"-components.patch
	"${FILESDIR}/${P}"-titletest.patch
)
