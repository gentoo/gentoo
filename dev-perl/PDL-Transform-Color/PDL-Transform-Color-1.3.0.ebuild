# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=1.003
DIST_AUTHOR=ZOWIE
inherit perl-module

DESCRIPTION="Useful color system conversions for PDL"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/PDL
	dev-perl/Safe-Isa
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
