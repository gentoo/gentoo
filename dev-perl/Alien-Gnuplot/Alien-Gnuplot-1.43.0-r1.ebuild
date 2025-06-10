# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=1.043
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Find and verify functionality of the gnuplot executable"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Alien-Build-0.250.0
	sci-visualization/gnuplot
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Alien-Build-2.190.0
	>=dev-perl/Alien-Base-ModuleBuild-0.320.0
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/File-Which
	test? ( dev-perl/Test-Exception )
"

PATCHES=( "${FILESDIR}/${PN}-1.43.0-version.patch" )
