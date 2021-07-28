# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=1.005
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Useful color system conversions for PDL"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/PDL
	dev-perl/Safe-Isa
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
